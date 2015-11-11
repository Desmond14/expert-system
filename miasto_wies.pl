:- dynamic
    xpozytywne/2,
    xnegatywne/2.

powinien_mieszkac_w(ustrzyki_gorne) :- woli_mieszkac(na_wsi),
                        wskazana_bliskosc(gory).
                        
powinien_mieszkac_w(krzyze) :- woli_mieszkac(na_wsi),
                        wskazana_bliskosc(woda).
                        
powinien_mieszkac_w(gdansk) :- woli_mieszkac(w_miescie),
                        wskazana_bliskosc(woda).
                        
powinien_mieszkac_w(krakow) :- woli_mieszkac(w_miescie),
                        wskazana_bliskosc(gory).

powinien_mieszkac_w(warszawa) :- woli_mieszkac(w_miescie),
                        preferuje_dojazd(komunikacja_miejska).				

woli_mieszkac(na_wsi) :- moze_mieszkac(na_wsi), spelnia_warunki(na_wsi).

woli_mieszkac(w_miescie) :- spelnia_warunki(w_miescie).

moze_mieszkac(na_wsi) :- pozytywne(czy, masz_prawo_jazdy).
moze_mieszkac(na_wsi) :- negatywne(czy, praca_zwiazana_z_miastem).

spelnia_warunki(na_wsi) :- negatywne(czy, wolisz_bliskosc_kina_niz_lasu),
                           pozytywne(czy, nie_przeszkadza_duza_odleglosc_do_sklepu).

spelnia_warunki(w_miescie) :- pozytywne(czy, wolisz_bliskosc_kina_niz_lasu),
                              pozytywne(czy, nie_przeszkadza_duzy_ruch).

wskazana_bliskosc(gory) :- pozytywne(czy, lubisz_chodzic_po_gorach).
wskazana_bliskosc(gory) :- pozytywne(czy, uprawiasz_sporty_zimowe).

wskazana_bliskosc(woda) :- pozytywne(czy, lubisz_wypoczywac_na_plazy).
wskazana_bliskosc(woda) :- pozytywne(czy, zeglujesz).

preferuje_dojazd(komunikacja_miejska) :- negatywne(czy, lubisz_jezdzic_autem).
preferuje_dojazd(komunikacja_miejska) :- pozytywne(czy, nie_przeszkadzaja_tlumy),
									     pozytywne(czy, lubisz_czytac_ksiazki).
						
pozytywne(X,Y) :- xpozytywne(X,Y), !.

pozytywne(X,Y) :- \+xnegatywne(X,Y), pytaj(X,Y,tak).

negatywne(X,Y) :- xnegatywne(X,Y), !.

negatywne(X,Y) :- \+xpozytywne(X,Y), pytaj(X,Y,nie).

pytaj(X,Y,tak) :- !, format('~w ~w ? (t/n)~n',[X,Y]),
                    read(Reply),
                    (Reply = 't'),
                    pamietaj(X,Y,tak).
                    
pytaj(X,Y,nie) :- !, format('~w ~w ? (t/n)~n',[X,Y]),
                    read(Reply),
                    (Reply = 'n'),
                    pamietaj(X,Y,nie).
                    
pamietaj(X,Y,tak) :- assertz(xpozytywne(X,Y)).

pamietaj(X,Y,nie) :- assertz(xnegatywne(X,Y)).

wyczysc_fakty :- write('Przycisnij cos aby wyjsc'), nl,
                    retractall(xpozytywne(_,_)),
                    retractall(xnegatywne(_,_)),
                    get_char(_).
                    
wykonaj :- powinien_mieszkac_w(X), !,
            format('~nTwoim wymarzonym miejscem do zycia moze byc ~w', X),
            nl, wyczysc_fakty.
            
wykonaj :- write('Nie jestem w stanie znalezc miejsca do zycia dla ciebie'), nl,
            wyczysc_fakty.