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
    bit sendTo = (_pid+1)%2 //There are only two processes

    bit buffered[8];   // buffer for output TODO: Geeignete Groesse waehlen

    // TODO: Modellieren Sie Prozess P, so dass er der Beschreibung entspricht
    do
        ::{
            if
                ::nBuffered<MAX_SEQ+1 ->{
                    bit sleceted
                    select(sleceted: 0..1); //create package
                    buffered[nBuffered]=sleceted
                    nBuffered =nBuffered+1;
                    network ! sendTo, nextToSend, nextAckExpected, buffered[0];
                    nextToSend = nextToSend+1;
                }
                ::else
            fi
            byte sequence, ack
            bit received
            if
                ::{
                    network? _pid, sequence, ack, received;
                    if
                        ::sequence==frameExpected->{
                            frameExpected= (frameExpected+1)%(MAX_SEQ+1); 
                            byte i, x;
                            for (i:nextAckExpected..ack){ 
                                for (x:0..nBuffered-1){ 
                                    buffered[x]=buffered[x+1]
                                }
                                nBuffered = nBuffered-1;
                            }
                            nextAckExpected=ack+1
                        }
                        ::else
                    fi
                }
                ::else
            fi
        } 

    od
}

active proctype Q() {
    byte nextToSend;
    byte frameExpected;
    
    // TODO: Modellieren Sie Prozess Q, so dass er der Beschreibung entspricht
}
