A simple implementation of the AVL tree algorithm
NOTE: This is not production level code. Merely an exercise in
implementing the algorithm.

Extra Super Special AWESOME Thanks to @nahi and his perfect
[implementation](https://github.com/nahi/avl_tree)

When in doubt -- go back to your 
[uni](https://docs.google.com/viewer?a=v&q=cache:v0IXKU5xel0J:www.cs.washington.edu/education/courses/cse373/04wi/slides/lecture08.ppt+&hl=en&pid=bl&srcid=ADGEESiQn4WGxRaNDtEwfJTkw-Y733A5AmofjWd75tyEEh_nLj1fTxfvvlGVRfJutWdVgva_9i4_3CCKTBdjAWUxdEUlsyMwLE4dXoR70v-isk6bgWrxGYSYdQEtKVnBlwo2xf6wSV5N&sig=AHIEtbRLac798Xyb3H9WVAE8y57Tcu-CAw)

Insertion and balancing is relatively easy so I am not going to waste
too many bits on it.

These are my notes

#Left Rotation#
     g                  p
      \                / \
       p    -->       g   n
      / \              \
     T   n              T
```c
p : node pointer;
p := n.right;
n.right := p.left;
p.left := n;
n := p
```
#Right Rotation#
         g              p
        /              / \
       p    -->       n   g
      / \            /
     n   T          T

```c
p : node pointer;
p := n.left;
n.left := p.right;
p.right := n;
n := p
```
When balancing the tree we back up the chain of ancestors from insert or delete actions
until we hit a node that is out of balance. When the tree is out of balance in a specific
direction, we check the opposite node of the heavy side to see if it is higher than its
sibling, and perform an inside rotation against that child on the heavy side
prior to doing the standard rotation.
    
I've read explanations like that for days... and they make little sense so here's an example.

```pre
          A
           \
            C
           /
          B
```

A's right tree has a height of 2, while its empty left tree has a height of 0.
This gives node A a balance factor or 2 (right heavy) and invalidates the tree's requirement that
balance factors must be between -1 and 1 (left leaning, balanced, right leaning)
    
Before we can do the left rotation of C, we need to have a look at C's balance as well.
    
If C's balance is in the opposite direction of the tree's balance.
(e.g. A-balance_factor: 2, C-balance_factor: -1)
    
We right_rotate to get:

```pre
       A
        \
         B
          \
           C
```

And then left rotate A to get:

```pre
         B
        / \
       A   C
```

The inverse applies, but that that is really all there is to it.
Look at the code, I am sure you will get it.

#Node Deletion For Idiots Like Me#
#A.K.A - Get Out of My Tree#

Just like insertion, we are going to walk down the tree looking for
the node that we need to delete. When we find it, that is where the
Magic begins. In fact, instead of calling it P, or t or n or any of
the other useless symbols you find in so many references, let's be 
creative and call it: *The node we want to delete*.

What we do with the node we want to delete depends on the state of
its children. But don't worry, we have magic spells to handle this.

Level 1: Simple Vanishing Spell
Being a first level spell, this one is hard to get wrong. We simply walk
down the tree until we find the the node we want to delete and as it
does not have any children, we simply replace it with our terminal leaf
and rebalance the tree up the path we searched.

Level 2: The Parent-Kid Swap Spell
Only marginally more difficult that Magic Spells Level 1, again we walk
down the tree until we find the node we want to delete and as it only
has one child we replace the node we want to delete with that child and
walk back up the tree rebalancing at each node.

Level 10: Fit An Elephant Into Your Shoe Spell

Yeah, thats right, we are going to take a huge leap in complexity in
order to delete a node that has two children. So take a deep breath,
and remember that if I can figure it out, this is going to be absolute
cake for you.

Like the two spells above, we still need to walk down the tree to find
the node we want to delete, and when we are done we will still walk
back up the tree rebalancing as needed. But lo, we discover that it has
not one child, but two. Those children may have children of their own.
We could be deleting the grandparent of some poor, newly added node!
And let me tell you, that grandchild is in for a hell of a surprise!

Like any great dynasty, when the head of the family passes away someone
must step up and take their place. Sometimes, like in the case of our
tree, it is arranged by outside forces so let's call that node

*the usurper*
(again, none of that 'x' or 'n' foolishness here, please)

#The Usurper#

Let's consider the following tree.

```pre
      4
    /   \
   2     6
  / \   / \
 1   3 5   8
          / \
         7   9
```

The node we want to delete is 4, and yes 4 could be a child of some
other node. It does not have to be root, we just don't have to care if it
is or not.

So who is the usurper?
Who will dare to take over for this grand node 4?

Now, I could give you the same, overly mind warping 'tis the last right
node of the right tree of the left child' BS you find in so many
references. ...but I wont...
Those explanations are not wrong.
They just confuse the shit out of me.

Here is an explanation of the incantations required to find the usurper
that I hope might actually make a bit of sense.

Now! Tell me quickly! Quickly!
Which node is the 'in order successor' of four?
What about the 'in order predecessor'?

To these questions, I hope you answer:

WHO CARES - get your overly-specific alienating terminology out of my
face, mate.

What those REALLY SMART PEOPLE wanted to say (and probably spent days
    arguing over when they could have been out drinking beer) was

"The next node" and "The previous node"

Consider the same data in a flat array:

[1, 2, 3, 4, 5, 6, 7, 8, 9]

What is "the previous node" before 4?

THREE

And What is "the next node" after four?

FIVE

See how easy that is? The usurper must be one of those two rascals.

We could also say that "The previous node" is the
maximum of all values that are smaller than the node we want to delete.

Also, we can say that 'the next node' is the minimum of all the values 
that are bigger than the node we want to delete.

But we are creeping closer to those guys who never have time for a beer.

Also, we can say that the In Order Predecessor is the right most node of the
left child tree of P, or the inverse, the In Order Successor is the left
most node of the right subtree of P - but that would make me want to hit
something - or someone. Then I would be sent to a place where they wont
let me drink ANY beer, and what's the fun in that?

So the usurper must be either 3 or 5. But which one do we chose?
Well, don't even need to think about it!
Just chose the child of the node we want to delete that is shortest.
If they are both the same size, it doesnt matter, just pick one!

Oh - and remember to ask for directions!
Let's look at that tree again:

            4
          /   \
         2     6
        / \   / \
       1   3 5   8
                / \
               7   9

Remember that 4 is "the node we want to delete"
If I tasked you to find the usurper, what would you do?

I hope you would be asking your self "Which tree is shorter?"
Ah, yes the left tree.
- The usurper has to be smaller than four - so we need to go left....
- And it would have to be bigger than 2, so we go right...
OOOOOHHH that was "the previous node" from the flat array. Oh my flaming cow
patties this tree stuff actually works! - beer time!

Lets try to formalize that process a bit.

When the left tree of 'the node we want to delete' is shorter than the
right:

From the node we want to delete, just turn left, take your next
right and keep going straight until you hit the end of the road.

That last node is the usurper.

If the right tree of the node we want to delete is shorter than the 
left:

From the node we want to delete, turn right, take your next left 
and keep going straight until you hit the end of the road.

Now that you have found the usurper, things are pretty easy.

1. Remove the usurper from the tree (Replace it with a terminal node)

2. Balance all the nodes we passed while we were looking for the usurper

3. Give the left and right children of the node we want to delete to the
usurper.

4. Continue back up the tree balancing until we get back to the root.

PRESTO

#Copyright and License
----------
AvlTree &copy; 2012 by [Randy Morgan](digital.ipseity@gmail.com)
AvlTree is licensed under the MIT license. Please see the LICENSE document for more information.
