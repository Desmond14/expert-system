:- dynamic
    zapamietane/3.

powinien_mieszkac_w(ustrzyki_gorne) :- woli_mieszkac(na_wsi),
                        wskazana_bliskosc(gory),
						lubi(odosobnienie).
                        
powinien_mieszkac_w(krzyze) :- woli_mieszkac(na_wsi),
                        wskazana_bliskosc(woda).
                        
powinien_mieszkac_w(gdansk) :- woli_mieszkac(w_miescie),
                        wskazana_bliskosc(woda).
                        
powinien_mieszkac_w(krakow) :- woli_mieszkac(w_miescie),
						lubi(miasta_turystyczne),
                        wskazana_bliskosc(gory).

powinien_mieszkac_w(warszawa) :- woli_mieszkac(w_miescie),
                        preferuje_dojazd(komunikacja_miejska).	

powinien_mieszkac_w(rzeszow) :- woli_mieszkac(w_miescie),
							preferuje_dojazd(auto).
powinien_mieszkac_w(rzeszow) :- woli_mieszkac(w_miescie),
							wskazana_bliskosc(gory).
							
powinien_mieszkac_w(zakopane) :- wskazana_bliskosc(gory),
								pytaj(czy, nie_przeszkadza_duzy_ruch),
								pytaj(czy, nie_przeszkadzaja_tlumy).
								
powinien_mieszkac_w(sandomierz) :- lubi(miasta_turystyczne),
									pytaj(czy, lubisz_serial_ojciesz_mateusz).

powinien_mieszkac_w(wroclaw) :- woli_mieszkac(w_miescie),
								pytaj(czy, zalezy_na_bliskosci_duzego_zoo).

woli_mieszkac(na_wsi) :- moze_mieszkac(na_wsi), spelnia_warunki(na_wsi).

woli_mieszkac(w_miescie) :- spelnia_warunki(w_miescie).

moze_mieszkac(na_wsi) :- pytaj(czy, masz_prawo_jazdy).
moze_mieszkac(na_wsi) :- \+pytaj(czy, praca_zwiazana_z_miastem).

spelnia_warunki(na_wsi) :- \+pytaj(czy, wolisz_bliskosc_kina_niz_lasu),
                           pytaj(czy, nie_przeszkadza_duza_odleglosc_do_sklepu).

spelnia_warunki(w_miescie) :- pytaj(czy, wolisz_bliskosc_kina_niz_lasu),
                              pytaj(czy, nie_przeszkadza_duzy_ruch).

wskazana_bliskosc(gory) :- pytaj(czy, lubisz_chodzic_po_gorach).
wskazana_bliskosc(gory) :- pytaj(czy, uprawiasz_sporty_zimowe).

wskazana_bliskosc(woda) :- pytaj(czy, lubisz_wypoczywac_na_plazy).
wskazana_bliskosc(woda) :- pytaj(czy, zeglujesz).

preferuje_dojazd(komunikacja_miejska) :- \+pytaj(czy, lubisz_jezdzic_autem).
preferuje_dojazd(komunikacja_miejska) :- pytaj(czy, nie_przeszkadzaja_tlumy),
									     pytaj(czy, lubisz_czytac_ksiazki).
										 
lubi(miasta_turystyczne) :- pytaj(czy, nie_przeszkadzaja_tlumy),
							pytaj(czy, lubisz_zwiedzac_zabytki),
							pytaj(czy, lubisz_zwiedzac_muzea).
							
lubi(odosobnienie) :- \+pytaj(czy, nie_przeszkadzaja_tlumy),
                        pytaj(czy, nie_przeszkadza_brak_lub_slaby_zasieg_telefoniczny).
										 
preferuje_dojazd(auto) :- pytaj(czy, lubisz_jezdzic_autem),
                          pytaj(czy, masz_prawo_jazdy).

pytaj(X,Y) :- zapamietane(X, Y, tak),
              !.
			  
pytaj(X,Y) :- zapamietane(X, Y, _),
              !,
			  fail.
                    
pytaj(X,Y) :- format('~w ~w ? (t/n)~n',[X,Y]),
                    read(Reply),
                    pamietaj(X, Y, Reply),
					(Reply = 't').
					
pamietaj(X, Y, 't') :- assertz(zapamietane(X, Y, tak)), !.
pamietaj(X, Y, _) :- assertz(zapamietane(X, Y, nie)).

wyczysc_fakty :- write('Przycisnij cos aby wyjsc'), nl,
                    retractall(zapamietane(_,_,_)),
                    get_char(_).
                    
wykonaj :- powinien_mieszkac_w(X), !,
            format('~nTwoim wymarzonym miejscem do zycia moze byc ~w', X),
            nl, wyczysc_fakty.
            
wykonaj :- write('Nie jestem w stanie znalezc miejsca do zycia dla ciebie'), nl,
            wyczysc_fakty.