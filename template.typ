
#let nutriscore(score) = {
  let col = if score == "a" {
    green
  } else if score == "b" {
    rgb(102, 255, 102)
  } else if score == "c" {
    yellow
  } else if score == "d" {
    orange
  } else if score == "e" {
    red
  } else if score == "?" {
    gray
  };
  box(circle(fill: col, inset: 2pt)[#set align(center + horizon); #set text(font: "Menlo", fill: black); 
*#upper(score)*])
}

#let fold_sum(a, k) = { a + k };

#let display_product(prod) = {
  ([#nutriscore(prod.nutriscore)], [#link(prod.url)[#prod.name]], [#calc.round(prod.scale) g/ml],
  [#calc.round(prod.nutriments.energy) kcal],
[#calc.round(prod.nutriments.carbohydrates, digits: 2)
#prod.units.carbohydrates],
  [#calc.round(prod.nutriments.proteins, digits: 2) #prod.units.proteins],
  [#calc.round(prod.nutriments.fat, digits: 2) #prod.units.fat], [#calc.round(prod.nutriments.salt, digits: 2) #prod.units.salt])
}

#let create_pseudo_product(name, cals, carbs, proteins, fats, salts, url: "", nutriscore: "?", scale: 1.0) = {
  (name: name, scale: scale,
    nutriments: (carbohydrates: carbs, energy: cals, proteins: proteins, fat: fats, salt: salts), 
    units: (carbohydrates: "g", energy: "kcal", proteins: "g", fat: "g", salt: "g"),
    nutriscore: nutriscore,
    url: url,
  )
}

#let create_food_table(products) = {

  let carbohydrates = calc.round(products.map(p => p.nutriments.carbohydrates).fold(0, fold_sum), digits: 2);
  let proteins = calc.round(products.map(p => p.nutriments.proteins).fold(0, fold_sum), digits: 2);
  let fats = calc.round(products.map(p => p.nutriments.fat).fold(0, fold_sum), digits: 2);
  let energy = calc.round(products.map(p => p.nutriments.energy).fold(0, fold_sum));
  let salt = calc.round(products.map(p => p.nutriments.salt).fold(0, fold_sum), digits: 2);

  table(
    inset: 4pt,
    columns: (auto, 1fr, auto, auto, auto, auto, auto, auto),
    stroke: .5pt,
    fill: (col, row) => if (col > 1 and row > 0 and calc.even(col)) or (row == 0) { luma(245) } else { white },
    align: (col, row) =>
      if row == 0 { center + horizon }
      else if col == 0 or col == 1 { left + horizon }
      else { right + horizon },
    [], [*Nahrungsmittel*], [*Menge*], [*Energie*], [*KH*], [*Protein*], [*Fett*], [*Salz*],
    ..products.map(p => display_product(p)).flatten(),
    [], [], [], [_*#energy kcal*_], [_*#carbohydrates #products.at(0).units.carbohydrates*_], 
    [_*#proteins #products.at(0).units.proteins*_],
    [_*#fats #products.at(0).units.fat*_], [_*#salt #products.at(0).units.salt*_]
  )
}

#let calculate_stats(goal, meal_plan) = {
  let calories = calc.round(meal_plan.map(p => p.map(k => k.nutriments.energy).fold(0, fold_sum)).fold(0, fold_sum));
  let proteins = calc.round(meal_plan.map(p => p.map(k => k.nutriments.proteins).fold(0, fold_sum)).fold(0, fold_sum));
  let carbohydrates = calc.round(meal_plan.map(p => p.map(k => k.nutriments.carbohydrates).fold(0, fold_sum)).fold(0, fold_sum));
  let fat = calc.round(meal_plan.map(p => p.map(k => k.nutriments.fat).fold(0, fold_sum)).fold(0, fold_sum));
  let salt = calc.round(meal_plan.map(p => p.map(k => k.nutriments.salt).fold(0, fold_sum)).fold(0, fold_sum), digits: 1);

  (energy: calories, proteins: proteins, carbohydrates: carbohydrates, fat: fat, salt: salt)
}

#let colorize(k, goal, unit: "g") = {

  let dif = k - goal;

  stack(dir: ltr, spacing: 2pt,
    if dif > 0 { circle(fill: red, radius: 6pt, text(fill: white, "!")) },
    text(fill: if dif > 0 { red.darken(35%) } else { black })[#str(k)],
    text()[#"/" #str(goal) #unit]     
  )
}
 
#let create_overview(goal, meal_plan) = {
  let stats = calculate_stats(goal, meal_plan.values());

  table(
    inset: 6pt,
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    fill: (_, row) => if row == 0 { luma(245) } else { white },
    [*Energie*], [*Kohlenhydrate*], [*Protein*], [*Fett*], [*Salz*],
    [#colorize(stats.energy, goal.energy, unit: "kcal")], 
    [#colorize(stats.carbohydrates, goal.carbohydrates)], 
    [#colorize(stats.proteins, goal.proteins)], 
    [#colorize(stats.fat, goal.fat)], 
    [#colorize(stats.salt, goal.salt)]
  )
}

#let project(body) = {
  set text(font: "Linux Libertine", lang: "de", size: 9pt)
  set page("a4", margin: 40pt)
  /*show link: it => {
    set text(fill: blue.darken(30%))
    it
  }*/

  body
}
