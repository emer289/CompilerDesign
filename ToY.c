#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ToY.h"

/* current scope */
struct ScopeNode **cur_scope;

void init_hash_table(){
	int i;
	hash_table = malloc(SIZE * sizeof(list_t*));
	for(i = 0; i < SIZE; i++) hash_table[i] = NULL;
	cur_scope = malloc(sizeof(struct ScopeNode*));
	(*cur_scope) = malloc(sizeof(struct ScopeNode));
}

unsigned int hash(char *key){
	unsigned int hashval = 0;
	for(;*key!='\0';key++) hashval += *key;
	hashval += key[0] % 11 + (key[0] << 3) - key[0];
	return hashval % SIZE;
}

void insert(char *name, int len, int type, int lineno){
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];

	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;

	/* variable not yet in table */
	if (l == NULL){
		//if (type == 0) printf("here\n");
		l = (list_t*) malloc(sizeof(list_t));
		strncpy(l->st_name, name, len);
		/* add to hashtable */
		l->st_type = type;
		l->lines = (RefList*) malloc(sizeof(RefList));
		l->lines->lineno = lineno;
		l->lines->next = NULL;
		l->next = hash_table[hashval];
		hash_table[hashval] = l;
		//addToScope(l);
		printf("Inserted %s for the first time with linenumber %d!\n", name, lineno); // error checking
	}
	/* found in table, so just add line number */
	else{
		RefList *t = l->lines;
		while (t->next != NULL) t = t->next;
		/* add linenumber to reference list */
		t->next = (RefList*) malloc(sizeof(RefList));
		t->next->lineno = lineno;
		t->next->next = NULL;
		printf("Found %s again at line %d!\n", name, lineno);
	}
}

void withdraw(char *name) {
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	list_t *lprev;
	
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) 
	{
	  lprev = l;
	  l = l->next;
	}
	if (l == NULL)
	{
	  printf("%s does not exist to be deleted\n", name);
	} else {
	  if (lprev != NULL)
	  {
	    lprev->next = l->next;
	  }
	  free(l);
	}
}

list_t *lookup(char *name){ /* return symbol if found or NULL if not found */
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	return l; // NULL is not found
}

list_t *lookup_scope(char *name, int len){ /* return symbol if found or NULL if not found */
	//unsigned int hashval = hash(name);
	//list_t *l = hash_table[hashval];
	//while ((l != NULL) && (strcmp(name,l->st_name) != 0) && (scope != l->scope)) l = l->next;
	//return l; // NULL is not found
	
	printf("looking up scope: %s\n", name);
	
	struct ScopeNode **searchScope = cur_scope;
	struct ScopeLinkNode *l;
	
	//printf("curr scope %i\n", cur_scope);
	
	while (searchScope != NULL)
	{
	  l = (*searchScope)->scopeLinkHead;
	  //printf("%i\n", l);
	  
	  while (l != NULL)
	  {
		if (strcmp(name, l->listnode->st_name) == 0) {
			printf("match found\n");
			return l->listnode;
		}
		l = l->next;
	  }
	  printf("search scope seg check\n");
	  if ((*searchScope)->head == NULL) {
		  printf("not found in scope\n");
		  return NULL;
	  }
	  searchScope = &(*searchScope)->head;
	}
	return NULL;
}

void addToScope (list_t *l)
{
  printf("adding to scope: %s\n", l->st_name);
  struct ScopeLinkNode *cur = (*cur_scope)->scopeLinkHead;
  //printf("error there\n");
  if (cur == NULL) {
    cur = malloc(sizeof(struct ScopeLinkNode));
    cur->listnode = l;
    (*cur_scope)->scopeLinkHead = cur;
    printf("node added new in scope\n");
    return;
  }
  
  struct ScopeLinkNode *prev;
  while (cur != NULL) {
    prev = cur;
    cur = cur->next;
  }
  cur = malloc(sizeof(struct ScopeLinkNode));
  cur->listnode = l;
  prev->next = cur;
  printf("node added onto existing scope\n");
}

void hide_scope(){ /* hide the current scope */
	printf("hide scope\n");
	if((*cur_scope)->head != NULL) {
		printf("head not null\n");
		cur_scope = &(*cur_scope)->head;
	}
}

void incr_scope(){ /* go to next scope */
	printf("increase scope\n");
	struct ScopeNode *newScope = malloc(sizeof(struct ScopeNode));
	newScope->head = (*cur_scope);
	(*cur_scope) = newScope;
}

/* print to stdout by default */
void ToY_dump(FILE * of){
  int i;
  fprintf(of,"------------ ------ ------------\n");
  fprintf(of,"Name         Type   Line Numbers\n");
  fprintf(of,"------------ ------ -------------\n");
  for (i=0; i < SIZE; ++i){
	if (hash_table[i] != NULL){
		list_t *l = hash_table[i];
		while (l != NULL){
			RefList *t = l->lines;
			fprintf(of,"%-12s ",l->st_name);
			if (l->st_type == INT_TYPE) fprintf(of,"%-7s","int");
			else if (l->st_type == REAL_TYPE) fprintf(of,"%-7s","real");
			else if (l->st_type == STR_TYPE) fprintf(of,"%-7s","string");
			else if (l->st_type == ARRAY_TYPE){
				fprintf(of,"array of ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-7s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-7s","real");
				else if (l->inf_type  == STR_TYPE) 	   fprintf(of,"%-7s","string");
				else fprintf(of,"%-7s","undef");
			}
			else if (l->st_type == FUNCTION_TYPE){
				fprintf(of,"%-7s %s","function returns ");
				if (l->inf_type == INT_TYPE) 		   fprintf(of,"%-7s","int");
				else if (l->inf_type  == REAL_TYPE)    fprintf(of,"%-7s","real");
				else if (l->inf_type  == STR_TYPE) 	   fprintf(of,"%-7s","string");
				else fprintf(of,"%-7s","undef");
			}
			else fprintf(of,"%-7s","undef"); // if UNDEF or 0
			while (t != NULL){
				fprintf(of,"%4d ",t->lineno);
			t = t->next;
			}
			fprintf(of,"\n");
			l = l->next;
		}
    }
  }
}
