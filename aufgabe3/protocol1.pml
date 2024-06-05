#define MAX_SEQ 7

// Hilfsmakro, welches ueberprueft, dass '(a <= b < c)  or (c < a <= b) or (b < c < a)'
// Kann fuer die Implementierung von Prozess P nuetzlich sein.
#define between(a, b, c) ((a <= b) && (b < c)) || ((c < a) && (a <= b)) || ((b < c) && (c < a))

chan network = [8] of {bit, byte, byte, bit} /* TODO: Initialisieren Sie den Kanal (channel) */;

active proctype P() {
    byte nextToSend;         // used for outbound stream
    byte nextAckExpected;    // oldest frame not acknowledged
    byte frameExpected;      // next frame to expect to receive
    byte nBuffered;          // number of buffered frames
    bit sendTo = (_pid+1)%2     //There are only two processes, so the formula here can generate the second Process' ID

    bit buffered[8];   // buffer for output TODO: Geeignete Groesse waehlen
    
    byte sequence, ack // storage for the incoming frames variables
    bit received
    // TODO: Modellieren Sie Prozess P, so dass er der Beschreibung entspricht
    do
        ::nBuffered<MAX_SEQ+1 ->{
                    bit selected
                    select(selected: 0..1); //create package
                    buffered[nBuffered]=selected;
                    network ! sendTo, nextToSend, nextAckExpected, buffered[nBuffered];
                    nBuffered =nBuffered+1;
                    nextToSend = nextToSend+1;
        }
                      
            
        ::network? eval(_pid), sequence, ack, received->{
            if
                ::sequence==frameExpected->{
                    frameExpected= (frameExpected+1); 
                    byte i, x; //Remove acknowledged packets queue-style
                    for (i:nextAckExpected..ack){ 
                        for (x:0..nBuffered-2){ 
                            buffered[x]=buffered[x+1]
                        }
                        nBuffered = nBuffered-1;
                    }
                    nextAckExpected=(ack+1);
                }
                ::else   //Reject Frame
            fi
        }
        ::timeout->{
            byte i;
            for(i:0..nBuffered-1){
                network ! sendTo, nextAckExpected+i, nextAckExpected, buffered[i];
            }
        } 

    od
}

active proctype Q() {
    byte nextToSend;
    byte frameExpected;
    bit sendTo = (_pid+1)%2     //There are only two processes, so the formula here can generate the second Process' ID
    // TODO: Modellieren Sie Prozess Q, so dass er der Beschreibung entspricht
    byte sequence, ack // storage for the incoming frames variables
    bit received
    do
        ::network? eval(_pid), sequence, ack, received ->{
            if 
                ::sequence==frameExpected->{
                    network ! sendTo, nextToSend, sequence, 0;
                    nextToSend = nextToSend+1;
                    frameExpected= frameExpected+1;
                }
                :: else //Reject
            fi
        }
    od
}
