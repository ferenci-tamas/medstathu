# setwd

library( XLConnect ) # a nyers adatok beolvasásához
library( maptools ) # a térkép beolvasásához
library( scales ) # a muted színekhez
library( lattice ) # az ábrák kirajzolásához
library( grid ) # az utólagos felirat-kiíráshoz

### Előkészületek a longitudinális összehasonlításhoz ###

Adatok <- read.csv2( "rbe.csv" )

EWPopulation <- read.csv2( "EnglandAndWalesPopulation.csv" )

QuarterlyUK <- read.csv2( "Quarterly.csv" )
QuarterlyUK$YearRecode <- QuarterlyUK$Year+2/12+(QuarterlyUK$Quarter-1)*3/12
QuarterlyUK$All.ages <- apply( QuarterlyUK[ , 3:8 ], 1, sum )
QuarterlyUK <- merge( QuarterlyUK, EWPopulation, by = "Year" )
QuarterlyUK$HibMorbidity <- QuarterlyUK$All.ages/QuarterlyUK$Population*100*4

MonthlyUK <- read.csv2( "Monthly.csv" )
MonthlyUK <- merge( MonthlyUK, EWPopulation, by = "Year" )
MonthlyUK$BMorbidity <- MonthlyUK$Bcase/MonthlyUK$Population*52/(MonthlyUK$WeekEnd-MonthlyUK$WeekStart+1)
MonthlyUK$CMorbidity <- MonthlyUK$Ccase/MonthlyUK$Population*52/(MonthlyUK$WeekEnd-MonthlyUK$WeekStart+1)
MonthlyUK$YearRecode <- ((MonthlyUK$WeekStart+MonthlyUK$WeekEnd-1)/2)/52+MonthlyUK$Year
MonthlyUK <- MonthlyUK[ !is.na( MonthlyUK$BMorbidity ), ]
MonthlyUK <- MonthlyUK[ !is.na( MonthlyUK$CMorbidity ), ]
MonthlyUK <- MonthlyUK[ order( MonthlyUK$YearRecode ), ]

### Vonaldiagram ###

LineComp <- function( Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, Konyv, subsetting, autokey ) {
  p1 <- xyplot( Inc ~ Years, groups = groups, type = "l", xlab = "Év", ylab = "Morbiditás [Megbetegedés / év / 100e fő]",
                main = ifelse( Konyv, "", main ), ylim = c( 0, NA ), subset = ifelse( rep( subsetting, length( Inc ) ), !is.na( Inc ), TRUE ),
                lattice.options = modifyList( lattice.options(), list( skip.boundary.labels = 0 ) ), auto.key = autokey,
                panel = function( x, y, ... ) {
                  panel.grid( h = -1, v = -1 )
                  if ( length( Intro )==1 )
                    panel.abline( v = Intro )
                  else
                    panel.rect( Intro[ 1 ], current.panel.limits()$ylim[ 1 ], Intro[ 2 ], current.panel.limits()$ylim[ 2 ],
                                col = alpha( "gray", 0.2 ) )
                  panel.xyplot( x, y, grid = FALSE, ... )
                  IntroLast <- tail( Intro, 1 )
                  Displ <- diff( current.panel.limits()$xlim )
                  panel.arrows( IntroLast + 5*Displ/100, max( y, na.rm = TRUE )*0.9, IntroLast + Displ/100, max( y, na.rm = TRUE )*0.9,
                                length = 0.05 )
                  panel.text( IntroLast + 5*Displ/100, max( y, na.rm = TRUE )*0.9, arrowlab, pos = 4 )
                  if ( !is.null( Intro2 ) ) {
                    if ( length( Intro2 )==1 )
                      panel.abline( v = Intro2 )
                    else
                      panel.rect( Intro2[ 1 ], current.panel.limits()$ylim[ 1 ], Intro2[ 2 ], current.panel.limits()$ylim[ 2 ],
                                  col = alpha( "gray", 0.2 ) )
                    Intro2Last <- tail( Intro2, 1 )
                    panel.arrows( Intro2Last + 5*Displ/100, max( y, na.rm = TRUE )*0.9, Intro2Last + Displ/100, max( y, na.rm = TRUE )*0.9,
                                  length = 0.05 )
                    panel.text( Intro2Last + 5*Displ/100, max( y, na.rm = TRUE )*0.9, arrowlab2, pos = 4 )
                  }
                  
                } )
  p3 <- grid.text( "vedooltas.blog.hu\nFerenci Tamás, 2016", 0.2, 0.04, just = "centre", gp = gpar( font = 3, cex = 1 ), draw = FALSE )
  
  return( list( p1 = p1, p3 = p3 ) )
}

LinePlotter <- function( FileName, device, extension, Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting = FALSE,
                         autokey = FALSE, width = 9, height = 6, Konyv = FALSE, ... ) {
  p <- LineComp( Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, Konyv, subsetting, autokey )
  trellis.device( file = paste0( FileName, ".", extension ), device = device, width = width, height = height, ... )
  print( p$p1 )
  if( !Konyv )
    grid.draw( p$p3 )
  dev.off()
}

LineAllPlot <- function( FileName, Inc, Years, Intro, main, arrowlab, Intro2 = NULL, arrowlab2 = NULL, subsetting = FALSE, autokey = FALSE,
                         groups = rep( 1, length(Inc) ), ... ) {
  LinePlotter( FileName, "cairo_pdf", "pdf", Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting, autokey, ... )
  LinePlotter( FileName, "png", "png", Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting, autokey, units = "in", res = 300,
               ... )
  LinePlotter( FileName, "svg", "svg", Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting, autokey, ... )
  LinePlotter( paste0( FileName, "Konyv" ), "cairo_pdf", "pdf", Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting, autokey,
               Konyv = TRUE, ... )
  LinePlotter( paste0( FileName, "Konyv" ), "cairo_ps", "eps", Inc, Years, groups, Intro, main, arrowlab, Intro2, arrowlab2, subsetting, autokey,
               Konyv = TRUE, ... )
}

LineAllPlot( "./Abrak/LineKanyaroUS", Adatok$USMeasles, Adatok$Year, 1963,
             paste( "Kanyaró megbetegedések és a kanyaró elleni védőoltás az Egyesült Államokban,",
                    min( Adatok$Year[ !is.na( Adatok$USMeasles ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$USMeasles ) ] ) ),
             "Kanyaró elleni védőoltás\nbevezetése (1963)" )
LineAllPlot( "./Abrak/LineKanyaroUK", Adatok$UKMeasles, Adatok$Year, 1968,
             paste( "Kanyaró megbetegedések és a kanyaró elleni védőoltás\naz Egyesült Királyságban (Anglia és Wales),",
                    min( Adatok$Year[ !is.na( Adatok$UKMeasles ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$UKMeasles ) ] ) ),
             "Kanyaró elleni védőoltás\nbevezetése (1968)" )
LineAllPlot( "./Abrak/LineKanyaroHUN", Adatok$HUNMeasles, Adatok$Year, 1969,
             paste( "Kanyaró megbetegedések és a kanyaró elleni védőoltás Magyarországon,",
                    min( Adatok$Year[ !is.na( Adatok$HUNMeasles ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$HUNMeasles ) ] ) ),
             "Kanyaró elleni védőoltás\nbevezetése (1969)" )
LineAllPlot( "./Abrak/LinePertussisHUN", Adatok$HUNPertussis, Adatok$Year, 1954,
             paste( "Pertussis (szamárköhögés) megbetegedések\nés a pertussis elleni védőoltás Magyarországon,",
                    min( Adatok$Year[ !is.na( Adatok$HUNPertussis ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$HUNPertussis ) ] ) ),
             "Szamárköhögés elleni védőoltás\nbevezetése (1954)" )
LineAllPlot( "./Abrak/LinePertussisUS", Adatok$USPertussis, Adatok$Year, c( 1943, 1947 ),
             paste( "Pertussis (szamárköhögés) megbetegedések\nés a pertussis elleni védőoltás az Egyesült Államokban,",
                    min( Adatok$Year[ !is.na( Adatok$USPertussis ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$USPertussis ) ] ) ),
             "Szamárköhögés elleni védőoltás\n bevezetése (1940-es évek közepe)" )
LineAllPlot( "./Abrak/LinePertussisUK", Adatok$UKPertussis, Adatok$Year, 1957,
             paste( "Pertussis (szamárköhögés) megbetegedések\nés a pertussis elleni védőoltás az Egyesült Királyságban (Anglia és Wales),",
                    min( Adatok$Year[ !is.na( Adatok$UKPertussis ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$UKPertussis ) ] ) ),
             "Szamárköhögés\nelleni védőoltás\nbevezetése\n(1957)", c( 1975, 1985 ), "Oltásellenesek gerjesztette\npánik (1980 körül)",
             subsetting = TRUE )
LineAllPlot( "./Abrak/LineDiphtheriaUS", Adatok$USDiphteria, Adatok$Year, c( 1923, 1927 ),
             paste( "Diftéria (torokgyík) megbetegedések\nés a diftéria elleni védőoltás az Egyesült Államokban,",
                    min( Adatok$Year[ !is.na( Adatok$USDiphteria ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$USDiphteria ) ] ) ),
             "Diftéria elleni védőoltás\nbevezetése (1920-as évek közepe)" )
LineAllPlot( "./Abrak/LineHibUK", QuarterlyUK$HibMorbidity, QuarterlyUK$YearRecode, 1993,
             paste( "Haemophilus influenzae b (Hib) megbetegedések és a Hib elleni\nvédőoltás az Egyesült Királyságban (Anglia és Wales),",
                    min( QuarterlyUK$Year[ !is.na( QuarterlyUK$HibMorbidity ) ] ), "-",
                    max( QuarterlyUK$Year[ !is.na( QuarterlyUK$HibMorbidity ) ] ) ),
             "Hib elleni védőoltás\nbevezetése (1993)", 2003, "Hib elleni emlékeztető\noltás bevezetése (2003)" )
LineAllPlot( "./Abrak/LinePolioHUN", Adatok$HUNPolio, Adatok$Year, 1960,
             paste( "Járványos gyermekbénulás (polio) megbetegedések\nés a polio elleni védőoltás Magyarországon,",
                    min( Adatok$Year[ !is.na( Adatok$HUNPolio ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$HUNPolio ) ] ) ),
             "Polio elleni védőoltás\nbevezetése (1960)" )
LineAllPlot( "./Abrak/LinePolioUS", Adatok$USPolio, Adatok$Year, 1955,
             paste( "Járványos gyermekbénulás (polio) megbetegedések\nés a polio elleni védőoltás az Egyesült Államokban,",
                    min( Adatok$Year[ !is.na( Adatok$USPolio ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$USPolio ) ] ) ),
             "Polio elleni védőoltás\nbevezetése (1955)" )
LineAllPlot( "./Abrak/LinePolioUK", Adatok$UKPolio, Adatok$Year, 1958,
             paste( "Járványos gyermekbénulás (polio) megbetegedések\nés a polio elleni védőoltás az Egyesült Királyságban (Anglia és Wales),",
                    min( Adatok$Year[ !is.na( Adatok$UKPolio ) ] ), "-", max( Adatok$Year[ !is.na( Adatok$UKPolio ) ] ) ),
             "Polio elleni védőoltás\nbevezetése (1958)" )
LineAllPlot( "./Abrak/LineMenCUK", c( MonthlyUK$CMorbidity, MonthlyUK$BMorbidity ), rep( MonthlyUK$YearRecode, 2 ), 1999.9,
             paste( "Meningococcus C és B (Men C és B) megbetegedések és a Men C elleni\nvédőoltás az Egyesült Királyságban (Anglia és Wales),",
                    min( MonthlyUK$Year[ !is.na( MonthlyUK$CMorbidity ) ] ), "-",
                    max( MonthlyUK$Year[ !is.na( MonthlyUK$CMorbidity ) ] ) ),
             "Men C elleni védőoltás\nbevezetése (1999)", autokey = list( corner = c( 0.95, 0.95 ), lines = TRUE, points = FALSE ),
             groups = rep( c( "Men C", "Men B" ), each = length( MonthlyUK$CMorbidity ) ) )

### Előkészületek a keresztmetszeti összehasonlításhoz ###

EurMap <- readShapeSpatial( "CNTR_RG_60M_2010", IDvar = "CNTR_ID" )

CountryId <- readWorksheetFromFile( "CountryId.xls", sheet = 1 )
CountryCountryHun <- readWorksheetFromFile( "CountryCountryHun.xls", sheet = 1 )

MeaslesInc <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "MeaslesInc", check.names = FALSE ), CountryCountryHun,
                     by = "Country", all = TRUE )
MeaslesCases <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "MeaslesCases", check.names = FALSE ), CountryCountryHun,
                       by = "Country", all = TRUE )

MumpsInc <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "MumpsInc", check.names = FALSE ), CountryCountryHun,
                   by = "Country", all = TRUE )
MumpsCases <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "MumpsCases", check.names = FALSE ), CountryCountryHun,
                     by = "Country", all = TRUE )

RubellaInc <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "RubellaInc", check.names = FALSE ), CountryCountryHun,
                     by = "Country", all = TRUE )
RubellaCases <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "RubellaCases", check.names = FALSE ), CountryCountryHun,
                       by = "Country", all = TRUE )

PertussisInc <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "PertussisInc", check.names = FALSE ), CountryCountryHun,
                       by = "Country", all = TRUE )
PertussisCases <- merge( readWorksheetFromFile( "FobbEuCISID.xls", sheet = "PertussisCases", check.names = FALSE ), CountryCountryHun,
                         by = "Country", all = TRUE )

### Térkép ###

MapComp <- function( IncInput, ToAvg, main, CountryIdTable, Map, Konyv ) {
  Inc <- merge( IncInput, CountryIdTable )
  names( Inc )[ which( names( Inc ) == "id" ) ] <- "CNTR_ID"
  Map <- Map[ Map$CNTR_ID%in%unique( Inc$CNTR_ID ), ]
  Inc$avg <- apply( Inc[ , ToAvg ], 1, function( x ) if ( sum( !is.na( x ) )>1 ) mean( x, na.rm = TRUE ) else NA )
  Inc$avg[ Inc$avg == 0 ] <- min( Inc$avg[ Inc$avg > 0 ], na.rm = TRUE ) / 2 
  Inc$logavg <- log10( Inc$avg )
  row.names( Inc ) <- Inc$CNTR_ID
  atpoints <- seq( floor( min( Inc$logavg, na.rm = TRUE ) ), ceiling( max( Inc$logavg, na.rm = TRUE ) ), 0.01 )
  atlabs <- seq( ceiling( min( Inc$logavg, na.rm = TRUE )+0.0001 ), floor( max( Inc$logavg, na.rm = TRUE )-0.0001 ), 1 )
  Inc$logavg[ is.na( Inc$logavg ) ]<- 1000
  MapInc <- SpatialPolygonsDataFrame( Map, Inc )
  
  p1 <- spplot( MapInc, "logavg", ylim = c( 30, 75 ), xlim = c( -13, 45 ),  main = ifelse( Konyv, "", main ), at = c( atpoints, 1001 ),
                col.regions = c( colorRampPalette( c( "white", muted( "red" ) ) )( length( atpoints ) ), "gray" ),
                colorkey = list( col = colorRampPalette( c( "white", muted( "red" ) ) )( length( atpoints ) ),
                                 at = atpoints, labels = list( at = atlabs, labels = 10^atlabs ) ), useRaster = TRUE,
                scales = list( x = list( at = seq( -10, 40, 10 ) ), y = list( at = seq( 40, 70, 10 ) ) ),
                par.settings = list( panel.background = list( col = alpha( "grey", 0.4 ) ), axis.line = list( col = "transparent" ) ),
                panel = function( ... ) {
                  panel.abline( v = seq( -10, 40, 10 ), h = seq( 40, 70, 10 ), col = "white", lwd = 2 )
                  panel.abline( v = seq( -5, 35, 10 ), h = seq( 35, 65, 10 ), col = "white" )
                  panel.polygonsplot( ... )
                } )
  p2 <- grid.text( "Átlagos incidencia\nMegbetegedés / év / 100e fő\n(logaritmikus skála)", 0.95, 0.05, just = "right",
                   gp = gpar( cex = 0.7, font = 2 ), draw = FALSE )
  p3 <- grid.text( "vedooltas.blog.hu\nFerenci Tamás, 2016", 0.2, 0.05, just = "centre", gp = gpar( font = 3, cex = 1.5 ), draw = FALSE )
  
  return( list( p1 = p1, p2 = p2, p3 = p3 ) )
}

MapPlot <- function( FileName, device, extension, IncInput, ToAvg, main, CountryIdTable, Map, width = 11, height = 10, Konyv = FALSE, ... ) {
  p <- MapComp( IncInput, ToAvg, main, CountryIdTable, Map, Konyv )
  trellis.device( file = paste0( FileName, ".", extension ), device = device, width = width, height = height, ... )
  print( p$p1 )
  grid.draw( p$p2 )
  if( !Konyv )
    grid.draw( p$p3 )
  dev.off()
}

MapAllPlot <- function( FileName, IncInput, ToAvg, MainTitle, CountryIdTable, Map, width = 11, height = 10, ... ) {
  MapPlot( FileName, "cairo_pdf", "pdf", IncInput, ToAvg, MainTitle, CountryId, Map, width = width, height = height, ... )
  MapPlot( FileName, "png", "png", IncInput, ToAvg, MainTitle, CountryId, Map, width = width, height = height, units = "in", res = 300, ... )
  MapPlot( FileName, "svg", "svg", IncInput, ToAvg, MainTitle, CountryId, Map, width = width, height = height, ... )
  MapPlot( paste0( FileName, "Konyv" ), "cairo_pdf", "pdf", IncInput, ToAvg, MainTitle, CountryId, Map, width = width, height = height,
           Konyv = TRUE, ... )
  MapPlot( paste0( FileName, "Konyv" ), "cairo_ps", "eps", IncInput, ToAvg, MainTitle, CountryId, Map, width = width, height = height,
           Konyv = TRUE, ... )
}

MapAllPlot( "./Abrak/MapKanyaroEur", MeaslesInc,  8:12, "Kanyaró járványügyi helyzete Európában, 2009-2013", CountryId, EurMap )
MapAllPlot( "./Abrak/MapMumpszEur", MumpsInc,  8:12, "Mumpsz járványügyi helyzete Európában, 2009-2013", CountryId, EurMap )
MapAllPlot( "./Abrak/MapRubeolaEur", RubellaInc,  8:12, "Rubeola járványügyi helyzete Európában, 2009-2013", CountryId, EurMap )
MapAllPlot( "./Abrak/MapPertussisEur", PertussisInc,  8:12, "Szamárköhögés járványügyi helyzete Európában, 2009-2013", CountryId, EurMap )

### Oszlopdiagram ###

BarComp <- function( Inc, Cases, Years, Countries, main, Konyv ) {
  DiseaseLong <- merge( reshape( Inc, direction = "long", varying = names( Inc )[ 2:12 ], v.names = "Inc", timevar = "Year",
                                 times = 2003:2013 ),
                        reshape( Cases, direction = "long", varying = names( Cases )[ 2:12 ], v.names = "Cases",
                                 timevar = "Year", times = 2003:2013 ) )
  
  p1 <- barchart( Inc ~ Year | CountryHun, data = DiseaseLong, subset = Year%in%Years&Country%in%Countries, horizontal = FALSE,
                  ylab = "Morbiditás [Megbetegedés / év / 100e fő]", xlab = "", layout = c( length( Countries ), 1 ), origin = 0,
                  main = ifelse( Konyv, "", main ), Cases = DiseaseLong$Cases,
                  auto.key = list( space = "right", text = as.character( Years ), rectangles = TRUE, points = FALSE, title = "Év" ),
                  scales = list( x = list( draw = FALSE ) ), col = trellis.par.get()$superpose.polygon$col,
                  par.settings = list( layout.heights = list( bottom.padding = 7 ) ),
                  panel = function( x, y, Cases, subscripts, ... ) {
                    panel.barchart( x, y, ... )
                    #panel.text( x, y, labels = Cases[ subscripts ], pos = rep( c( 3, 1 ), length.out = length( x ) ) )
                    panel.text( x, y, labels = Cases[ subscripts ], pos = 3, cex = 0.7 )
                  } )
  
  p2 <- grid.text( "Az oszlopokon lévő számok az esetszámot mutatják", 0.85, 0.06, just = "right", gp = gpar( cex = 0.7, font = 2 ),
                   draw = FALSE )
  p3 <- grid.text( "vedooltas.blog.hu\nFerenci Tamás, 2016", 0.2, 0.06, just = "centre", gp = gpar( font = 3, cex = 1.5 ), draw = FALSE )
  
  return( list( p1 = p1, p2 = p2, p3 = p3 ) )
}

BarPlotter <- function( FileName, device, extension, Inc, Cases, Years, Countries, main, width = 11, height = 6, Konyv = FALSE, ... ) {
  p <- BarComp( Inc, Cases, Years, Countries, main, Konyv )
  trellis.device( file = paste0( FileName, ".", extension ), device = device, width = width, height = height, ... )
  print( p$p1 )
  grid.draw( p$p2 )
  if( !Konyv )
    grid.draw( p$p3 )
  dev.off()
}

BarAllPlot <- function( FileName, Inc, Cases, Years, Countries, main, width = 11, height = 6, ... ) {
  BarPlotter( FileName, "cairo_pdf", "pdf", Inc, Cases, Years, Countries, main, width = width, height = height, ... )
  BarPlotter( FileName, "png", "png", Inc, Cases, Years, Countries, main, width = width, height = height, units = "in", res = 300, ... )
  BarPlotter( FileName, "svg", "svg", Inc, Cases, Years, Countries, main, width = width, height = height, ... )
  BarPlotter( paste0( FileName, "Konyv" ), "cairo_pdf", "pdf", Inc, Cases, Years, Countries, main, width = width, height = height,
              Konyv = TRUE, ... )
  BarPlotter( paste0( FileName, "Konyv" ), "cairo_ps", "eps", Inc, Cases, Years, Countries, main, width = width, height = height,
              Konyv = TRUE, ... )
}

BarAllPlot( "./Abrak/BarKanyaroEur", MeaslesInc, MeaslesCases, 2009:2013,
            c( "United Kingdom of Great Britain and Northern Ireland", "Switzerland", "Germany", "France", "Austria", "Hungary" ),
            "Kanyaró járványügyi helyzete egyes európai országokban, 2009-2013" )
BarAllPlot( "./Abrak/BarMumpszEur", MumpsInc, MumpsCases, 2009:2013,
            c( "United Kingdom of Great Britain and Northern Ireland", "Hungary" ),
            "Mumpsz járványügyi helyzete egyes európai országokban, 2009-2013" )
BarAllPlot( "./Abrak/BarRubeolaEur", RubellaInc, RubellaCases, 2009:2013,
            c( "United Kingdom of Great Britain and Northern Ireland", "Switzerland", "Austria", "Hungary" ),
            "Rubeola járványügyi helyzete egyes európai országokban, 2009-2013" )
BarAllPlot( "./Abrak/BarPertussisEur", PertussisInc, PertussisCases, 2009:2013,
            c( "United Kingdom of Great Britain and Northern Ireland", "Austria", "Hungary" ),
            "Szamárköhögés járványügyi helyzete egyes európai országokban, 2009-2013" )