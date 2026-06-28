# Hands-on Activity: visualizing data with ggplot2
library(ggplot2)
library(palmerpenguins)
data("penguins")
View(penguins)
ggplot(data = penguins) + geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g))

# create your own plot
View(Orange)
data("Orange")
ggplot(data = Orange) + geom_point(mapping = aes(x = age, y = circumference))

# Getting started with ggplot
library(tidyverse)
ggplot(data = penguins) + geom_point(mapping = aes(x = bill_length_mm, y = bill_depth_mm))

ggplot(data = penguins) +
  geom_smooth(mapping = aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g))

# seperate line for each species of penguin
ggplot(data = penguins) +
  geom_smooth(mapping = aes(x=flipper_length_mm, y=body_mass_g, linetype=species)) 

# geom_gitter
ggplot(data = penguins) +
  geom_jitter(mapping=aes(x=flipper_length_mm, y=body_mass_g))

#   BAR CHARTS
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x=cut, fill=clarity))

# FACETS
# facet wrap
ggplot(data = penguins) +
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  facet_wrap(~species)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x=color, fill=cut)) +
  facet_wrap(~cut)

# facet grid
# facet wrap
ggplot(data = penguins) +
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  facet_grid(sex~species)

ggplot(data=penguins) +
  geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species",  caption="Data collected by Dr. Kristen Gorman") +
  annotate("text", x=220, y=3500, label="The Gentoos are the largest", color="purple", fontface="bold", size=4.5, angle=25)

# annotation as a variable
p <- ggplot(data=penguins) +
  geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species",  caption="Data collected by Dr. Kristen Gorman")

p + annotate("text", x=220, y=3500, label="The Gentoos are the largest", color="purple", fontface="bold", size=4.5, angle=25)

# SAVING YOUR VISUALIZATIONS
ggplot(data=penguins) +
  geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g, color=species))

ggsave("Three Penguin Species.png")
