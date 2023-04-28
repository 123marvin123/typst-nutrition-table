use crate::prelude::*;
use openfoodfacts::{self as off, Locale, Output};
use std::collections::HashMap;
use typst::eval::{Module, Scope, Value};

pub fn module() -> Module {
    let mut off = Scope::deduplicating();

    off.define("product", product);

    Module::new("off").with_scope(off)
}

/// Display: Product
/// Category: OpenFoodFacts
/// Returns: dict
#[comemo::memoize]
#[func]
pub fn product(
    /// The barcode of the product to query.
    barcode: EcoString,
    /// How to scale the nutriment values.
    #[named]
    #[default(Ratio::one())]
    scaled: Ratio,
    /// Additional notes that should be attached to the product.
    #[named]
    #[default(EcoString::new())]
    notes: EcoString,
) -> Value {
    if scaled.is_zero() {
        panic!("scale cannot be zero.");
    }

    let client = off::v2().locale(Locale::from("de")).build().unwrap();
    let output = Output::new().fields("product_name,nutriments,nutriscore_grade");

    let response = client.product(barcode.as_str(), Some(output));
    let mut status_code = 0;
    let scale = scaled.get();
    let scale_fn = |f: f64| Some(f * scale);

    let mut result = Dict::new();

    if let Ok(content) = response {
        let json: HashMap<String, serde_json::Value> = content.json().unwrap();
        let product: &serde_json::Value = json.get("product").unwrap();

        status_code = json.get("status").unwrap().as_i64().unwrap();

        result.insert("name".into(), product["product_name"].as_str().unwrap().into());
        result.insert("scale".into(), (scale * 100.0).into());
        let nutriments = &product["nutriments"];
        let mut nutriment_dict = Dict::new();

        nutriment_dict.insert(
            "proteins".into(),
            nutriments["proteins_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "carbohydrates".into(),
            nutriments["carbohydrates_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "energy".into(),
            nutriments["energy-kcal_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "fat".into(),
            nutriments["fat_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "salt".into(),
            nutriments["salt_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "saturated-fat".into(),
            nutriments["saturated-fat_100g"].as_f64().and_then(scale_fn).into(),
        );

        nutriment_dict.insert(
            "sugar".into(),
            nutriments["sugars_100g"].as_f64().and_then(scale_fn).into(),
        );

        let mut units_dict = Dict::new();

        units_dict.insert("proteins".into(), nutriments["proteins_unit"].as_str().into());
        units_dict.insert(
            "carbohydrates".into(),
            nutriments["carbohydrates_unit"].as_str().into(),
        );
        units_dict
            .insert("energy".into(), nutriments["energy-kcal_unit"].as_str().into());
        units_dict.insert("fat".into(), nutriments["fat_unit"].as_str().into());
        units_dict.insert("salt".into(), nutriments["salt_unit"].as_str().into());
        units_dict.insert(
            "saturated-fat".into(),
            nutriments["saturated-fat_unit"].as_str().into(),
        );
        units_dict.insert("sugar".into(), nutriments["sugars_unit"].as_str().into());

        result.insert("nutriments".into(), nutriment_dict.into());
        result.insert("units".into(), units_dict.into());

        result.insert(
            "nutriscore".into(),
            product
                .get("nutriscore_grade")
                .unwrap_or(&serde_json::Value::from("?"))
                .as_str()
                .into(),
        );

        result.insert(
            "url".into(),
            format!("https://world.openfoodfacts.org/product/{}", barcode.as_str())
                .into(),
        );
    }

    result.insert("notes".into(), notes.into());

    result.insert("ok".into(), if status_code == 0 { false.into() } else { true.into() });
    result.into()
}
