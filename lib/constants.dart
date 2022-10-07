import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangeureut/models/search_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

const kBackgroundColor = Color(0xFFFFFFFF);

const kBackgroundColor2 = Color(0xFFF6F3EE);

const kBasicColor = Color(0xff8f9e52);

const kSecondaryColor = Color(0xFF9A9D78);

const kThirdColor = Color(0xFFD8D8D3);

const kBasicTextColor = Color(0xFF52504B);

const kSecondaryTextColor = Color(0xFF3C3E24);

const kHintTextColor = Color(0xff8B867D);

const kBorderGreenColor = Color(0xff868F7D);

const tasteProfileIconPath = "images/icons/onboarding_icon";

Icon kBasicBackIcon = Icon(
  Icons.arrow_back_ios,
  color: kBasicTextColor.withOpacity(0.8),
);

Map onboarding_initial = {
  "alcoholType": {
    alcoholTypeList[0]: false,
    alcoholTypeList[1]: false,
    alcoholTypeList[2]: false,
    alcoholTypeList[3]: false,
    alcoholTypeList[4]: false,
    alcoholTypeList[5]: false,
  },
  "tasteKeyword": {
    keyWordList[0]: false,
    keyWordList[1]: false,
    keyWordList[2]: false,
    keyWordList[3]: false,
    keyWordList[4]: false,
    keyWordList[5]: false,
    keyWordList[6]: false,
    keyWordList[7]: false,
    keyWordList[8]: false,
    keyWordList[9]: false,
    keyWordList[10]: false,
    keyWordList[11]: false,
  }
};

Map stationColor = {
  "안암역": Color(0xffcd7c2f),
  "회기역": Color(0xff0033a0),
  "외대앞역": Color(0xff0033a0),
  "신촌역": Color(0xff009d3e),
  "성신여대입구역": Color(0xff00a5de),
  "광흥창역": Color(0xffcd7c2f),
  "서울대입구역": Color(0xff009d3e),
};

const keyWordList = [
  "taste_baby",
  "taste_grandmother",
  "taste_daddy",
  "taste_bread",
  "taste_rice",
  "taste_visual",
  "taste_raw",
  "taste_meat",
  "taste_diet",
  "taste_spicy1",
  "taste_spicy2",
  "taste_sweet",
];

const keyWordList2 = [
  ["taste_baby", "애기입맛"],
  ["taste_grandmother", "할매입맛"],
  ["taste_daddy", "아재입맛"],
  ["taste_bread", "빵순이"],
  ["taste_rice", "밥순이"],
  ["taste_visual", "눈으로 먹어요"],
  ["taste_raw", "날 것 좋아"],
  ["taste_meat", "고기 좋아"],
  ["taste_diet", "건강 챙겨"],
  ["taste_spicy1", "맵찔이"],
  ["taste_spicy2", "맵고수"],
  ["taste_sweet", "달달구리 좋아"],
];

const alcoholTypeList2 = [
  ["alcohol_beer", "소주"],
  ["alcohol_soju", "맥주"],
  ["alcohol_liquor", "양주"],
  ["alcohol_traditional", "전통주"],
  ["alcohol_wine", "와인"],
  ["alcohol_cocktail", "칵테일"],
];

const alcoholTypeList = [
  "alcohol_soju",
  "alcohol_beer",
  "alcohol_liquor",
  "alcohol_traditional",
  "alcohol_wine",
  "alcohol_cocktail"
];

const alcoholTypeMap = {
  "alcohol_soju": "소주",
  "alcohol_beer": "맥주",
  "alcohol_liquor": "양주",
  "alcohol_traditional": "전통주",
  "alcohol_wine": "와인",
  "alcohol_cocktail": "칵테일",
};

const defaultAlcoholType = {
  "alcohol_soju": false,
  "alcohol_beer": false,
  "alcohol_liquor": false,
  "alcohol_traditional": false,
  "alcohol_wine": false,
  "alcohol_cocktail": false,
};

const kTitleStyle = TextStyle(
    fontFamily: 'Cafe24',
    color: kBasicColor,
    fontSize: 42.0,
    fontWeight: FontWeight.w700);

const kTitleStyle2 = TextStyle(
    fontFamily: 'GmarketSans',
    color: kBasicColor,
    fontSize: 55.0,
    fontWeight: FontWeight.w700);

const spicyLevelText = [
  "진라면도 순한맛 먹어",
  "신라면 정도까지야!",
  "불닭볶음면 좋아해!",
  "엽떡은 가장 매운맛이지"
];

const Map filterMap = {
  MainFilter.meal: {
    MainFilter.meal: ["images/filters/meal.png", "밥 한그릇"],
    MealSubFilter.cheap: ["images/filters/meal/cheap.png", "값싸게 먹을래"],
    MealSubFilter.vibe: ["images/filters/meal/vibe.png", "분위기 챙길래"],
    MealSubFilter.light: ["images/filters/meal/light.png", "가볍게 먹을래"],
    MealSubFilter.warm: ["images/filters/meal/warm.png", "따듯한 한상"],
    MealSubFilter.spicy: ["images/filters/meal/spicy.png", "매운게 땡겨"],
    MealSubFilter.greasy: ["images/filters/meal/greasy.png", "배에 기름칠"],
  },
  MainFilter.alcohol: {
    MainFilter.alcohol: ["images/filters/alcohol.png", "술 한잔"],
    AlcoholSubFilter.cheap: ["images/filters/alcohol/cheap.png", "값싸게 마실래"],
    AlcoholSubFilter.beer: ["images/filters/alcohol/beer.png", "소주랑 맥주"],
    AlcoholSubFilter.makgeoli: [
      "images/filters/alcohol/makgeoli.png",
      "파전에 막걸리"
    ],
    AlcoholSubFilter.taste: ["images/filters/alcohol/taste.png", "안주가 맛집"],
    AlcoholSubFilter.wineCocktail: [
      "images/filters/alcohol/cocktail.png",
      "분위기 챙길래"
    ],
    AlcoholSubFilter.turnDown: [
      "images/filters/alcohol/turnDown.png",
      "조용히 마실래"
    ],
  },
  MainFilter.coffee: {
    MainFilter.coffee: ["images/filters/coffee.png", "커피 한입"],
    CoffeeSubFilter.study: ["images/filters/coffee/study.png", "공부하기 좋은"],
    CoffeeSubFilter.talk: ["images/filters/coffee/talk.png", "도란도란 대화"],
    CoffeeSubFilter.vibe: ["images/filters/coffee/vibe.png", "감성 분위기"],
    CoffeeSubFilter.desert: ["images/filters/coffee/desert.png", "달달한 디저트"],
    CoffeeSubFilter.coffee: ["images/filters/coffee/coffee.png", "커피가 맛있는"],
    CoffeeSubFilter.cheap: ["images/filters/coffee/cheap.png", "저렴한 가격"],
  }
};

const profileIcons = [
  "🍕",
  "🍔",
  "🍟",
  "🌮",
  "🥗",
  "🌯",
  "🍜",
  "🥘",
  "🍝",
  "🍲",
  "🍛",
  "🍣",
  "🍎",
  "🍑",
  "🍰",
  "🍱",
  "🍤",
  "🍙",
  "🍏",
  "🍐",
  "🍊",
  "🍚",
  "🍘",
  "🍥",
  "🍋",
  "🍉",
  "🍌",
  "🍢",
  "🍡",
  "🍧",
  "🍇",
  "🍓",
  "🍈",
  "🍨",
  "🍦",
  "🎂",
  "🍍",
  "🥝",
  "🍅",
  "🍮",
  "🍭",
  "🍬",
  "🍆",
  "🥑",
  "🥒",
  "🍫",
  "🍿",
  "🍩",
  "🌶",
  "🌽",
  "🥕",
  "🥜",
  "🌰",
  "🍯",
  "🥔",
  "🍠",
  "🥐",
  "🥛",
  "🍼",
  "☕",
  "🍞",
  "🥖",
  "🧀",
  "🍾",
  "🍵",
  "🍺",
  "🍶",
  "🍳",
  "🥞",
  "🍖",
  "🥃",
  "🍸",
  "🍻",
  "🍹",
  "🥂",
  "🍗",
  "🥓",
  "🌭",
];
