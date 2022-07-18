class Node
    attr_accessor :value, :left_child, :right_child

    def initialize(value, left_child = nil, right_child = nil)
        @value = value
        @left_child = left_child
        @right_child = right_child
    end
end

class Tree
    attr_accessor :root

    def initialize(array)
        @array = array
        @array.uniq!
        @array.sort!
        @root = build_tree(@array)
    end

    def build_tree(arr, root = nil)
        middle = arr.length / 2
        left_arr = arr[0...middle]
        right_arr = arr[(middle + 1)...arr.length]

        root = Node.new(arr[middle])
        
        if !left_arr.empty?
            root.left_child = build_tree(left_arr, root)
        end

        if !right_arr.empty?
            root.right_child = build_tree(right_arr, root)
        end

        return root
    end

    def insert(value, root = @root)
        if value > root.value
            if root.right_child
                insert(value, root.right_child)
                
            else
                root.right_child = Node.new(value)
            end
        else
            if root.left_child
                insert(value, root.left_child)

            else
                root.left_child = Node.new(value)
            end
        end
    end

    def delete(value, root = @root)
        if root and value
            if value > root.value
                delete(value, root = root.right_child)

            elsif value < root.value
                delete(value, root = root.left_child)

            else
                if !root.right_child and !root.left_child
                    root.value = nil

                elsif !root.right_child and root.left_child
                    root = root.left_child
                    root.left_child = nil

                elsif root.right_child and !root.left_child
                    root = root.right_child
                    root.right_child = nil

                else
                    inorder_array = inorder([], [], root)
                    successor = nil
                    inorder_array.delete(nil)
                
                    for i in 0...inorder_array.length
                        if inorder_array[i] == root.value
                            successor = inorder_array[i + 1]
                        end
                    end

                    if !successor
                        if root.right_child.value
                            successor = root.right_child.value

                        elsif root.left_child.value
                            successor = root.left_child.value
                        end
                    end

                    delete(successor)
                    root.value = successor
                end
            end
        end
    end

    def find(value, root = @root, return_node = false, return_levels = false, return_array = false, levels = 0)
        if root
            if root.value == value
                if return_node
                    return root

                elsif return_levels
                    return levels

                else
                    return pretty_print(node = root)
                end

            else
                levels += 1
                if value > root.value
                    find(value, root.right_child, return_node, return_levels, return_array, levels)

                else
                    find(value, root.left_child, return_node, return_levels, return_array, levels)
                end
            end

        else
            if return_node
                return nil
            end

            puts "#{value} is not a node in this tree"
        end
    end

    def level_order(queue = [], arr = [], parent = @root, levels = 1, return_levels = false, &block)
        queue.shift

        if parent
            queue.push(parent.left_child)
            queue.push(parent.right_child)
            arr.push(parent.value)
        end

        if !queue.empty?
            levels += 1
            level_order(queue, arr, parent = queue[0], levels, return_levels)
        end

        if block
            for node in arr
                yield node
            end
        end

        if return_levels
            return levels
        end

        return arr
    end

    def inorder(queue = [], arr = [], parent = @root, &block)
        if parent.left_child
            queue.push(parent)
            inorder(queue, arr, parent = parent.left_child)

        else
            if !queue.empty?
                arr.push(parent.value)
                root = queue.last
                queue.pop
                arr.push(root.value)
                if root.right_child
                    inorder(queue, arr, parent = root.right_child)

                else
                    if !queue.empty?
                        root = queue.last
                        queue.pop
                        arr.push(root.value)
                        if root.right_child
                            inorder(queue, arr, parent = root.right_child)
                        end
                    end
                end
            
            else
                arr.push(parent.value)
            end
        end

        if block
            for node in arr
                yield node
            end
        end

        return arr
    end

    def preorder(queue = [], arr = [], parent = @root, &block)
        arr.push(parent.value)

        if queue.empty?
            queue.push(parent.left_child, parent.right_child)
        end

        for child in queue
            if child and !arr.include?(child.value)
                preorder(queue = [], arr, parent = child)
            end
        end

        if block
            for node in arr
                yield node
            end
        end

        return arr
    end

    def postorder(queue = [], arr = [], parent = @root, right_traverse = false, levels = [0], return_levels = false, &block)
        if parent
            if right_traverse == false
                if parent.left_child
                    queue.push(parent)
                    postorder(queue, arr, parent = parent.left_child, right_traverse, levels, return_levels)

                elsif parent.right_child
                    queue.push(parent)
                    postorder(queue, arr, parent = parent.right_child, right_traverse, levels, return_levels)
                
                else
                    arr.push(parent.value)
                    if !queue.empty?
                        postorder(queue, arr, parent = queue.last, right_traverse = true, levels, return_levels)
                    end
                end

            else
                if parent.right_child and arr.include?(parent.right_child.value) or !parent.right_child
                    arr.push(parent.value)
                    queue.pop

                    if parent.value
                        levels[0] += 1
                    end

                    if !queue.empty?
                        postorder(queue, arr, parent = queue.last, right_traverse = true, levels, return_levels)
                    end
                
                elsif parent.right_child
                    postorder(queue, arr, parent = parent.right_child, right_traverse = false, levels, return_levels)
                
                else
                    arr.push(parent.value)
                    queue.pop

                    if parent.value
                        levels[0] += 1
                    end

                    if !queue.empty?
                        postorder(queue, arr, parent = queue.last, right_traverse = true, levels, return_levels)
                    end
                end
            end

            if return_levels
                return levels
            end
    
            if block
                for node in arr
                    yield node
                end
            end
    
            return arr
        end
    end

    def height(node, return_difference = false)
        begin
            root = find(value = node, root = @root, return_node = true)
            right_tree = postorder(queue = [], arr = [], parent = root.right_child, right_traverse = false, levels = [0], return_levels = true)[0]
            left_tree = postorder(queue = [], arr = [], parent = root.left_child, right_traverse = false, levels = [0], return_levels = true)[0]
        rescue
            if root
                height = 1
            
            else
                height = "#{node} is not a node in this tree"
            end

        else
            if right_tree > left_tree
                difference = right_tree - left_tree
                height = right_tree + 1
    
            else
                difference = left_tree - right_tree
                height = left_tree + 1
            end
        end

        if return_difference
            return difference
        end

        return height
    end

    def depth(node)
        depth = find(value = node, root = @root, return_node = false, return_levels = true, levels = 0)
        return depth
    end

    def balanced?
        if height(@root.value, return_difference = true) > 1
            puts "This tree is not balanced"

        else
            puts "This tree is balanced"
        end
    end

    def rebalance
        node_array = inorder
        node_array.delete(nil)

        @root = build_tree(node_array)
        
        return to_s
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        if node.value != nil
            pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
            puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
            pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
        end
    end

    def to_s
        return pretty_print
    end
end