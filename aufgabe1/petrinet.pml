#define N 5

inline geldEinwurf() {
	if
   	 :: places[0] > 0 -> places[0]--; places[1]++; printf("Transition: Geld-Einwurf\n");
	    assert(places[0] >= 0 && places[1] >= 0);
    	fi;
}

inline geldRueckgabe() {
	if
    	:: places[1] > 0 -> places[1]--; places[0]++; printf("Transition: Geld-Rueckgabe\n");
	   assert(places[0] >= 0 && places[1] >= 0);
    	fi;
}

inline kaufAktion() {
	if
	:: places[1] > 0 && places[2] > 0 -> places[2]--; places[1]--; places[3]++; places[4]++; printf("Transition: Kaufaktion\n");
	   assert(places[1] >= 0 && places[2] >= 0 && places[3] >= 0 && places[4] >= 0);
	fi
}

inline keksEssen() {
	if
	:: places[4] > 0 -> places[4]--; printf("Transition: Keks Essen\n");
	   assert(places[4] >= 0);
	fi
}

active proctype P() {
	short places[N];
	places[0] = 3; /*Geldboerse*/
	places[2] = 2; /*Keksspeicher*/
	short gesamtGeld = places[0];
	short geld;

	do
    	:: geldEinwurf(); geld = places[0] + places[1] + places[3]; assert(geld == gesamtGeld);
	:: geldRueckgabe(); geld = places[0] + places[1] + places[3]; assert(geld == gesamtGeld);
   	:: kaufAktion(); geld = places[0] + places[1] + places[3]; assert(geld == gesamtGeld);
	:: keksEssen(); geld = places[0] + places[1] + places[3];  assert(geld == gesamtGeld);
	:: places[2] == 0 || places[0] == 0 -> break;
    	od;

end: printf("Keine Kekse mehr verfügbar\n");

}
