# Python program to reverse alternate 
# levels of a binary tree

# To simulate an XOR linked list, each node is assigned a unique id,
# and we maintain a global dictionary 'memory' mapping ids to nodes.

memory = {}

class Node:
    nextId = 1
    def __init__(self, data):
        self.data = data
        self.both = 0  # XOR of previous and next node ids
        self.id = Node.nextId
        Node.nextId += 1
        memory[self.id] = self

class XORLinkedList:
    def __init__(self):
        self.head = None
        self.tail = None

    def XOR(self, a, b):
        id_a = a.id if a is not None else 0
        id_b = b.id if b is not None else 0
        xor_id = id_a ^ id_b
        return memory.get(xor_id, None)

    # Insert a node at the head of the list
    def insertAtHead(self, data):
        newNode = Node(data)
        newNode.both = self.head.id if self.head is not None else 0
        if self.head is not None:
            self.head.both = self.head.both ^ newNode.id
        else:
            self.tail = newNode
        self.head = newNode

    # Insert a node at the tail of the list
    def insertAtTail(self, data):
        newNode = Node(data)
        newNode.both = self.tail.id if self.tail is not None else 0
        if self.tail is not None:
            self.tail.both = self.tail.both ^ newNode.id
        else:
            self.head = newNode
        self.tail = newNode

    # Delete a node from the head of the list
    def deleteFromHead(self):
        if self.head is None:
            return
        temp = self.head
        nextNode = memory.get(self.head.both, None) if self.head.both != 0 else None
        if nextNode is not None:
            nextNode.both = nextNode.both ^ self.head.id
        else:
            self.tail = None
        del memory[self.head.id]
        self.head = nextNode

    # Delete a node from the tail of the list
    def deleteFromTail(self):
        if self.tail is None:
            return
        temp = self.tail
        prevNode = memory.get(self.tail.both, None) if self.tail.both != 0 else None
        if prevNode is not None:
            prevNode.both = prevNode.both ^ self.tail.id
        else:
            self.head = None
        del memory[self.tail.id]
        self.tail = prevNode

    # Print the elements of the list
    def printList(self):
        current = self.head
        prev = None
        while current is not None:
            print(current.data, end=" ")
            next_id = current.both ^ (prev.id if prev else 0)
            prev = current
            current = memory.get(next_id, None)
        print()

if __name__ == "__main__":
    lst = XORLinkedList()
    lst.insertAtHead(10)
    lst.insertAtHead(20)
    lst.insertAtTail(30)
    lst.insertAtTail(40)
    # prints 20 10 30 40
    lst.printList()
    lst.deleteFromHead()
    # prints 10 30 40
    lst.printList()
    lst.deleteFromTail()
    # prints 10 30
    lst.printList()

