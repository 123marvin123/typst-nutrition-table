#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with()

#let meal_plan = (
  // Frühstück
  breakfast: (
    off.product("4071800038568", scaled: 168%),
    off.product("23382077", scaled: 87%),
    off.product("4056489037798", scaled: 165%),
  ),
  // Mittag
  lunch: (
    off.product("9120048498889", scaled: 125%),
    off.product("4337185459863", scaled: 100%),
    create_pseudo_product("Knoblauch", 4, 0.9, 0.2, 0, 0.01, url: "https://fddb.info/db/de/lebensmittel/naturprodukt_knoblauch_frisch/index.html", nutriscore: "a"),
    off.product("4056489269274", scaled: 5%),
    off.product("21273667", scaled: 100%),
    off.product("4061458005814", scaled: 7%),
    off.product("4056489115946", scaled: 140%),
    create_pseudo_product("Paprika, rot", 28, 4.8, 1, 0.4, 0.01, url: "https://fddb.info/db/de/lebensmittel/naturprodukt_paprika_rot_frisch_54/index.html", nutriscore: "a"),
    off.product("20673543", scaled: 225%),
  ),
  // Abend
  dinner: (
    off.product("24269797", scaled: 24%),
    off.product("27166734", scaled: 25%),
    off.product("4000339457823", scaled: 25%),
    off.product("23031326", scaled: 152%),
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