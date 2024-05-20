# Generate a simple plot and output to PPTX
# Demo for packages officer & rvg
# Malcolm Gillies <malcolm.gillies@unsw.edu.au>
# UNSW School of Population Health R Appreciation Society
# 2024-05-20

OUT="pptx-example.pptx"

library(ggplot2)
library(dplyr)
library(magrittr)
library(rvg)
library(officer)
library(readr)
library(extrafont)

adm2 <- read_csv("pptx-example.csv") %>%
	mutate(Label=sprintf("%.2g%%", Rate)) %>%
	mutate(Rate=Rate/100) %>%
	filter(Phase=="Initiation")

p1 <- ggplot(adm2, aes(x=Type, y=Rate)) +
  
    geom_col(position="dodge") + 

    geom_text(aes(label=Label), color="white", fontface="bold",
	position=position_dodge(width=0.9), hjust=1.1) +
  
    scale_y_continuous(name = "Initiation", labels=scales::percent) +

    coord_flip()

my_vec_graph <- dml(ggobj=p1,
	fonts = list(sans = "Arial", serif = "Times", mono = "Courier"),
	pointsize=10)

pptx <- read_pptx()
pptx <- add_slide(pptx, layout = "Title and Content", master = "Office Theme")
pptx <- ph_with(pptx, "Opioid initiation",
	location = ph_location_type(type = "title"))
pptx <- ph_with(pptx, my_vec_graph, location = ph_location_type(type="body"))

print(pptx, target = OUT)
