import java.util.*;

class Node {
    int data;
    int both; // XOR of previous and next node ids
    int id;
    static int nextId = 1;
    
    Node(int data) {
        this.data = data;
        this.both = 0;
        this.id = nextId++;
    }
}

class GFG {
    Node head;
    Node tail;
    // Global memory map to simulate pointer addresses
    static Map<Integer, Node> memory = new HashMap<>();

    // XOR function for Node pointers
    Node XOR(Node a, Node b) {
        int idA = (a == null) ? 0 : a.id;
        int idB = (b == null) ? 0 : b.id;
        int xorId = idA ^ idB;
        return memory.get(xorId);
    }

    // Constructor to initialize 
    // an empty list
    GFG() {
        head = tail = null;
    }

    // Insert a node at the head of the list
    void insertAtHead(int data) {
        Node newNode = new Node(data);
        memory.put(newNode.id, newNode);
        newNode.both = (head == null) ? 0 : head.id;
        if (head != null)
            head.both = head.both ^ newNode.id;
        else {
            // If the list was empty, the new
            // node is both the head and the tail
            tail = newNode;
        }
        head = newNode;
    }

    // Insert a node at the tail of the list
    void insertAtTail(int data) {
        Node newNode = new Node(data);
        memory.put(newNode.id, newNode);
        newNode.both = (tail == null) ? 0 : tail.id;
        if (tail != null)
            tail.both = tail.both ^ newNode.id;
        else {
            // If the list was empty, the new
            // node is both the head and the tail
            head = newNode;
        }
        tail = newNode;
    }

    // Delete a node from the head
    // of the list
    void deleteFromHead() {
        if (head == null)
            return;
        Node temp = head;
        Node next = (head.both == 0) ? null : memory.get(head.both);
        if (next != null) {
            next.both = next.both ^ head.id;
        } else {
            tail = null;
        }
        memory.remove(head.id);
        head = next;
    }

    // Delete a node from the tail
    // of the list
    void deleteFromTail() {
        if (tail == null)
            return;
        Node temp = tail;
        Node prev = (tail.both == 0) ? null : memory.get(tail.both);
        if (prev != null) {
            prev.both = prev.both ^ tail.id;
        } else {
            head = null;
        }
        memory.remove(tail.id);
        tail = prev;
    }

    // Print the elements of the list
    void printList() {
        Node current = head;
        Node prev = null;
        while (current != null) {
            System.out.print(current.data + " ");
            int nextId = current.both ^ (prev == null ? 0 : prev.id);
            Node next = memory.get(nextId);
            prev = current;
            current = next;
        }
        System.out.println();
    }

    public static void main(String[] args) {
        GFG list = new GFG();
        list.insertAtHead(10);
        list.insertAtHead(20);
        list.insertAtTail(30);
        list.insertAtTail(40);

        // prints 20 10 30 40
        list.printList();

        list.deleteFromHead();

        // prints 10 30 40
        list.printList();

        list.deleteFromTail();

        // prints 10 30
        list.printList();
    }
}

