# Mini Progetti R
In questa repository metterò tutti i mini progetti che ho scritto i R.<br>
## Generatore di mail
Semplice codice per generare una mailing list, utile nel caso si abbia un elenco di persone che sono affiliate ad una organizzazione/azienda/università che impiega una propria mail.
## Regioni Italiane
In questo progetto mi sono concentrato sulla rappresentazione cartografica dell'Italia. <br>
Apperentemente può sembrare semplice, ma non esistono pacchetti che contengono i dati sulle regioni italiane, quindi se si vuole rappresentare un fenomeno su scala regionale o provinciale è necessario scaricare i dati e processarli con R.<br>
Ho quindi scaricato i dati in formato *.shp* dal [sito dell'ISTAT](https://www.istat.it/it/archivio/222527).<br>
Il passaggio successivo è stato quello di convertire il file *.shp* in un formato che R fosse in grado di leggere.<br>
Per farlo mi sono avvalso del pacchetto **rgdal**:
```R
mappa <- rgdal::readOGR(dsn = paste0(getwd(), "/Limiti01012022_g/Reg01012022_g"))
```
L'oggetto *mappa* è una lista che ho provveduto a convertire in un dataframe tramite una funzione del pacchetto **broom**; ho poi creato un piccolo dataframe con i nomi delle regioni assegnando un *id* numerico per poter poi attribuire ad ogni punto (caratterizzato da una latitudine, una longitudine ed un gruppo di appartenenza) la regione corrispondente.

```R
df<-broom::tidy(mappa)

regioni <- data.frame(mappa@data$DEN_REG)
names(regioni) <- c("Regioni")
regioni$id <- seq(0,nrow(regioni)-1)
df$id <- as.numeric(df$id)
mappa_df <- right_join(df, regioni, by = "id")
```
Una volta ottenuto il dataframe *mappa_df* ho poi scaricato i dati del ministero della salute sulle infezioni da **Monkey Pox Virus** e li ho importati in R:

```R
casi <- read.csv("casi_monkeypox.csv", sep = ";", row.names = NULL)
```
Ho verificato ce i nomi delle regioni corrispondessero a quelli dei dati ISTAT:
```R
sort(unique(casi$Regioni)) == sort(unique(mappa_df$Regioni))
```
Ed ho infine unito i due dataframe:
```R
mappa_df <- left_join(mappa_df, casi, by = "Regioni")
```
Una volta fatto ciò ho potuto provvedere alla rappresentazione grafica del mio dataframe tramite **ggplot**:
```R
ggplot() +
  geom_polygon(
  data = mappa_df,
  aes( x = long, y = lat, group=group, fill = Casi), color="black") +
  scale_fill_continuous(low = "#C2FFBC", high = "#FF6E6E") +
  theme_void()+
  ggtitle("Monkey-pox cases in Italy (19/08/2022)")
```
Il risultato così ottenuto è il seguente! 
![Mappa ottenuta](https://github.com/MrCalaMD/MiniProgettiR/blob/main/Regioni%20italiane/Mappa.jpeg)



