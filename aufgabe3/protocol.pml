#define MAX_SEQ 7

// Hilfsmakro, welches ueberprueft, dass '(a <= b < c)  or (c < a <= b) or (b < c < a)'
// Kann fuer die Implementierung von Prozess P nuetzlich sein.
#define between(a, b, c) ((a <= b) && (b < c)) || ((c < a) && (a <= b)) || ((b < c) && (c < a))

chan network = /* TODO: Initialisieren Sie den Kanal (channel) */;

active proctype P() {
    byte nextToSend;         // used for outbound stream
    byte nextAckExpected;    // oldest frame not acknowledged
    byte frameExpected;      // next frame to expect to receive
    byte nBuffered;          // number of buffered frames

    bit buffered[/*..*/];   // buffer for output TODO: Geeignete Groesse waehlen

    // TODO: Modellieren Sie Prozess P, so dass er der Beschreibung entspricht
}

active proctype Q() {
    byte nextToSend;
    byte frameExpected;
    
    // TODO: Modellieren Sie Prozess Q, so dass er der Beschreibung entspricht
}
