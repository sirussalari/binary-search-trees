# binary-search-trees

This project is part of the Odin Project Curriculum.

Binary search trees are data structures where the central concept is to have a root node with left and right divisions. The left division contains nodes that are less in value compared to the root node, and the right division contains nodes that are greater in value compared to the root node.

The formation of a binary search tree starts with a sorted array of values. The root value is found by looking for the center value in the array. The left subtree is comprised of all of the values before the root value, and the right subtree is comprised of all of the values after the root value. The tree is then made by recursively defining the left and right child of each node, starting with the root node.

One of the main advantages of binary search trees is their time complexity to add and delete data is much faster than arrays. Although, this advantage is only true when the binary search tree is balanced (the height difference between the left and right subtrees for every node is no greater than 1).

In this project, I created two different classes, where one class is responsible for creating nodes with value, left child, and right child attributes. The other class is responsible for creating the actual tree. All the user needs to do to create the tree is to pass in an array of data. In this particular program, the class automatically sorts the array upon initiation, so it is not necessary for the user to supply a sorted array.

There are 11 key methods that users can use:

    1. #insert - users pass in a value, and the value will be placed in the appropiate spot in the tree.

    2. #delete - users pass in a value, and the value will be removed from the tree. In addition, if their are children of the deleted node, these children are rearranged based on an algorithm centered around finding successors through an inorder traversal.

    3. #find - users pass in a value, and the program will return the subtree where the value is the root of the tree.

    4. #level_order, preorder, postorder, inorder - these are enumerable methods, where users can pass in a block and the program traverses the data using the appropiate traversing algorithm. If no block is used, the program returns an array of the values sorted corresponding to the traversal method.

    5. #height - the user passes in a value, and the program will return the height of that node.

    6. #depth - the user passed in a value, and the program will return the depth of the node.

    7. #balanced? - returns whether the tree is currently balanced or not.

    8. #rebalance - rebalances tree, and prints out the newly balanced tree.