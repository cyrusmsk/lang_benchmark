// C# program to implement XOR Linked List
// to add 1 to a number represented as an array
using System;
using System.Collections.Generic;

class Node {
    public int data;
    public int both; // XOR of previous and next node ids
    public int id;
    public static int nextId = 1;
    public Node(int data) {
        this.data = data;
        this.both = 0;
        this.id = nextId++;
        GFG.memory[this.id] = this;
    }
}

class GFG {
    Node head;
    Node tail;
    public static Dictionary<int, Node> memory = new Dictionary<int, Node>();

    // XOR function for Node pointers
    Node XOR(Node a, Node b) {
        int idA = (a == null) ? 0 : a.id;
        int idB = (b == null) ? 0 : b.id;
        int xorId = idA ^ idB;
        return memory.ContainsKey(xorId) ? memory[xorId] : null;
    }

    // Constructor to initialize an empty list
    public GFG() {
        head = tail = null;
    }

    // Insert a node at the head of the list
    public void insertAtHead(int data) {
        Node newNode = new Node(data);
        newNode.both = (head == null) ? 0 : head.id;
        if (head != null)
            head.both = head.both ^ newNode.id;
        else {
            // If the list was empty, the new node is both the head and the tail
            tail = newNode;
        }
        head = newNode;
    }

    // Insert a node at the tail of the list
    public void insertAtTail(int data) {
        Node newNode = new Node(data);
        newNode.both = (tail == null) ? 0 : tail.id;
        if (tail != null)
            tail.both = tail.both ^ newNode.id;
        else {
            // If the list was empty, the new node is both the head and the tail
            head = newNode;
        }
        tail = newNode;
    }

    // Delete a node from the head of the list
    public void deleteFromHead() {
        if (head == null)
            return;
        Node next = (head.both == 0) ? null : memory[head.both];
        if (next != null) {
            next.both = next.both ^ head.id;
        } else {
            tail = null;
        }
        memory.Remove(head.id);
        head = next;
    }

    // Delete a node from the tail of the list
    public void deleteFromTail() {
        if (tail == null)
            return;
        Node prev = (tail.both == 0) ? null : memory[tail.both];
        if (prev != null) {
            prev.both = prev.both ^ tail.id;
        } else {
            head = null;
        }
        memory.Remove(tail.id);
        tail = prev;
    }

    // Print the elements of the list
    public void printList() {
        Node current = head;
        Node prev = null;
        while (current != null) {
            Console.Write(current.data + " ");
            int nextId = current.both ^ (prev == null ? 0 : prev.id);
            Node next = memory.ContainsKey(nextId) ? memory[nextId] : null;
            prev = current;
            current = next;
        }
        Console.WriteLine();
    }

    public static void Main() {
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

