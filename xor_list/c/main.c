#include <stdio.h>
#include <stdlib.h>
#include <stdint.h> // Include stdint.h for uintptr_t

// Node structure of a memory-efficient doubly linked list
typedef struct Node {
    int data;
    struct Node* npx; // XOR of next and previous node
} Node;

// XOR function for C (casted pointer XOR)
Node* XOR(Node* a, Node* b) {
    return (Node*)((uintptr_t)a ^ (uintptr_t)b);
}

// Insert a node at the beginning of the XORed linked list
Node* insert(Node* head_ref, int data) {
    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->data = data;
    new_node->npx = head_ref;

    if (head_ref != NULL) {
        head_ref->npx = XOR(new_node, head_ref->npx);
    }

    return new_node; // Return new node as the updated head
}

// Print contents of doubly linked list in forward direction
void printList(Node* head) {
    Node* curr = head;
    Node* prev = NULL;
    Node* next;

    printf("Following are the nodes of Linked List:\n");

    while (curr != NULL) {
        // Print current node
        printf("%d ", curr->data);

        // Get address of next node: curr->npx is XOR of prev and next
        next = XOR(prev, curr->npx);

        // Update prev and curr for next iteration
        prev = curr;
        curr = next;
    }

    printf("\n");
}

// Driver code
int main() {
    /* Create following Doubly Linked List
       head-->40<-->30<-->20<-->10 */
    Node* head = NULL;
    head = insert(head, 10);
    head = insert(head, 20);
    head = insert(head, 30);
    head = insert(head, 40);

    // Print the created list
    printList(head);

    return 0;
}

