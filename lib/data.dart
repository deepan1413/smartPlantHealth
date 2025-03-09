class Plant {
  final String name;
  final String asset;
  final String model;

  Plant({required this.name, required this.asset, required this.model});
}

List<Plant> data = [
  Plant(
      name: "Rice",
      asset: 'assets/sheaf-of-rice-svgrepo-com(1).svg',
      model: 'Rice'),
  Plant(name: "Tomato", asset: 'assets/tomato.svg', model: 'Tomato'),
  Plant(name: "Sugarcane", asset: 'assets/sugarcane.svg', model: 'Sugarcane'),
  Plant(name: "Chili", asset: 'assets/chili.svg', model: 'Chili'),
  Plant(name: "Brinjal", asset: 'assets/brinjal.svg', model: 'Brinjal'),
  Plant(
      name: "potato", asset: 'assets/potato-svgrepo-com.svg', model: 'potato'),
  Plant(name: "Banana", asset: 'assets/banana.svg', model: 'Banana'),
  Plant(name: "Soybean", asset: 'assets/soybean.svg', model: 'Soybean'),
  Plant(name: "corn", asset: 'assets/corn-svgrepo-com.svg', model: 'corn'),
  Plant(name: "Groundnut", asset: 'assets/peanut.svg', model: 'Groundnut')
];

/*
Cotton
Tomato
Chili
Brinjal
Banana
Groundnut
Soybean
Rice
corn
potato

cotton.svg
tomato.svg
chili.svg
brinjal.svg
banana.svg
peanut.svg
soybean.svg
sheaf-of-rice-svgrepo-com(1).svg
corn-svgrepo-com.svg
potato-svgrepo-com.svg


{
    "plants": [
        {
            "name": "Rice (Paddy)",
            "diseases": [
                "Rice Blast (Magnaporthe oryzae)",
                "Brown Spot (Bipolaris oryzae)",
                "Sheath Blight (Rhizoctonia solani)"
            ]
        },
      
      Sugarcane completed
        {
            "name": "Sugarcane",
            "diseases": [
                "Red Rot (Colletotrichum falcatum)",
                "Rust (Puccinia melanocephala)",
                "Smut (Ustilago scitaminea)"
            ]
        },
       
        {
            "name": "Tomato",
            "diseases": [
                "Early Blight (Alternaria solani)",
                "Late Blight (Phytophthora infestans)",
                "Bacterial Wilt (Ralstonia solanacearum)"
            ]
        },
        {
            "name": "Chili (Capsicum)",
            "diseases": [
                "Chili Leaf Curl Virus (CLCV)",
                "Powdery Mildew (Leveillula taurica)",
                "Bacterial Blight (Xanthomonas campestris)"
            ]
        },
        {
            "name": "Brinjal (Eggplant)",
            "diseases": [
                "Early Blight (Alternaria solani)",
                "Fruit and Shoot Borer (Leucinodes orbonalis)",
                "Powdery Mildew (Leveillula taurica)"
            ]
        },
        {
            "name": "Banana",
            "diseases": [
                "Panama Disease (Fusarium oxysporum f.sp. cubense)",
                "Sigatoka Leaf Spot (Mycosphaerella fijiensis)",
                "Bacterial Wilt (Xanthomonas campestris)"
            ]
        },
        {
            "name": "Groundnut (Peanut)",
            "diseases": [
                "Rust (Puccinia arachidis)",
                "Late Leaf Spot (Phaeoisariopsis personata)",
                "Groundnut Bud Necrosis Virus (GBNV)"
            ]
        },
        {
            "name": "Soybean",
            "diseases": [
                "Soybean Rust (Phakopsora pachyrhizi)",
                "Frogeye Leaf Spot (Cercospora sojina)",
                "Root Rot (Rhizoctonia solani)"
            ]
        },
        {
            "name": "Rice (Paddy)",
            "diseases": [
                "Powdery Mildew (Uncinula necator)",
                "Downy Mildew (Plasmopara viticola)",
                "Bunch Rot (Botrytis cinerea)"
            ]
        }
    ]
}


  String ModelPathSelector() {
    if (modelName.toLowerCase() == "apple") {
      return 'models/Apple';
    } else if (modelName.toLowerCase() == "bellpepper") {
      return 'models/BellPepper';
    } else if (modelName.toLowerCase() == "cherry") {
      return 'models/Cherry';
    } else if (modelName.toLowerCase() == "corn") {
      return 'models/Corn';
    } else if (modelName.toLowerCase() == "grape") {
      return 'models/Grape';
    } else if (modelName.toLowerCase() == "peach") {
      return 'models/Peach';
    } else if (modelName.toLowerCase() == "potato") {
      return 'models/Potato';
    } else if (modelName.toLowerCase() == "rice") {
      return 'models/Rice';
    } else if (modelName.toLowerCase() == "tomato") {
      return 'models/Tomato';
    } else {
      return "";
    }
  }
*/