#import "template.typ": *

#show: project.with()

#let meal_plan = (
  // Frühstück
  breakfast: (
    off.product("28102052", scaled: 400%),
    off.product("4000540000108", scaled: 100%),
    off.product("4056489108481", scaled: 40%),
    create_pseudo_product("Heidelbeeren", 69, 11.1, 0.9, 0.9, 0, scale: 150, nutriscore: "a", url: "https://fddb.info/db/de/lebensmittel/naturprodukt_heidelbeeren_frisch/index.html"),
    off.product("21773044", scaled: 20%),
  ),
  // Mittag
  lunch: (
    off.product("9120048498889", scaled: 125%),
    off.product("4337185459863", scaled: 200%),
    create_pseudo_product("Knoblauch", 4, 0.9, 0.2, 0, 0.01, url: "https://fddb.info/db/de/lebensmittel/naturprodukt_knoblauch_frisch/index.html", nutriscore: "a"),
    off.product("4056489269274", scaled: 5%),
    off.product("21273667", scaled: 100%),
    off.product("4061458005814", scaled: 7%),
    off.product("4056489115946", scaled: 100%),
    create_pseudo_product("Paprika, rot", 28, 4.8, 1, 0.4, 0.01, url: "https://fddb.info/db/de/lebensmittel/naturprodukt_paprika_rot_frisch_54/index.html", nutriscore: "a"),
  ),
  // Abend
  dinner: (
    off.product("4071800000992", scaled: 112%),
    off.product("5013665115656", scaled: 40%),
    off.product("4056489108481", scaled: 250%),
    off.product("24540841", scaled: 60%),

  ),
  // Snacks
  snacks: (
   off.product("21136344", scaled: 50%),
   //off.product("4056489108481", scaled: 150%),
   //off.product("5391534951254", scaled: 20%),
  ),
)

#let goal = (
  energy: 2850,
  carbohydrates: 428,
  proteins: 150,
  fat: 60,
  salt: 5
)

= Frühstück

#create_food_table(meal_plan.breakfast)

= Mittagessen

#create_food_table(meal_plan.lunch)

= Abendessen

#create_food_table(meal_plan.dinner)

== Snacks

#create_food_table(meal_plan.snacks)

#v(1fr)

#set text(size: 11pt)

= _Balance_

_Verbleibende Nährstoffe zur Erreichung des Ziels:_

#create_overview(goal, meal_plan)