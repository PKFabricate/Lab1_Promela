/*
  single-track.pml
  Gerüst für die Modellierung eines eingleisigen Streckenabschnitts in Promela
*/

/* 2 Weichen
   left_switch == 0: Block 2 nach links mit Block 1 verbunden
   left_switch == 1: Block 2 nach links mit Block 4 verbunden
   right_switch == 0: Block 2 nach rechts mit Block 3 verbunden
   right_switch == 1: Block 2 nach rechts mit Block 5 verbunden
*/
bit left_switch = 0;
bit right_switch = 0;

// 5 Blöcke: 1,2,3,4,5 plus OUTSIDE
#define OUTSIDE  0

// nächster Block bezüglich Richtung 0 (links-nach-rechts) oder 1 (rechts-nach-links)
#define LEFT_TO_RIGHT  0
#define RIGHT_TO_LEFT  1

inline next_block(block, direction, next) {
   if
   :: direction == LEFT_TO_RIGHT ->
      if
      :: block == 1 -> next = 2
      :: block == 2 && right_switch == 0 -> next = 3
      :: block == 2 && right_switch == 1 -> next = 5
      :: block == 4 -> next = 2
      :: else -> next = OUTSIDE
      fi
   :: direction == RIGHT_TO_LEFT ->
      if
      :: block == 2 && left_switch == 0 -> next = 1
      :: block == 2 && left_switch == 1 -> next = 4
      :: block == 3 -> next = 2
      :: block == 5 -> next = 2
      :: else -> next = OUTSIDE
      fi      
   fi
}

// Anzahl der Züge auf einem Block
byte block_occupied[6];

/*
   Prozesstyp für einen Zug
   
   direction:
      Gibt die Zugrichtung an und hat den Wert LEFT_TO_RIGHT oder RIGHT_TO_LEFT.
*/
proctype train(bit direction) {
   // aktueller Block, auf dem sich der Zug befindet
   byte block;
   if
   :: direction == LEFT_TO_RIGHT -> block = 4
   :: direction == RIGHT_TO_LEFT -> block = 3
   fi
   // der Zug belegt den aktuellen Block
   block_occupied[block] ++;

   // Variable, um den nächsten Block zwischenzuspeichern
   byte next;

   // jetzt kann der Zug losfahren
   do
   :: next_block(block, direction, next);
      if
      :: next == OUTSIDE -> goto end
      :: else -> skip
      fi
      // Zug wechselt zum nächsten Block
      block_occupied[next] ++;
      block_occupied[block] --;
      block = next
   od
 end:
   // Zug verlässt die Strecke
   block_occupied[block] --;
}
