name_attrs = [
  ["エマ", 1, "音楽と猫と美味しいものが好き！"],
  ["オリビア", 1, "クリエイターさんと話してみたい。"],
  ["エヴァ", 1, "プロフィールをご覧いただきありがとうございます。東京でWebマーケティング関連の仕事をしています。"],
  ["ノア", 0, "東京で美容師をしています。"],
  ["リアム", 0, "普段は公認会計士として働いています"],
  ["オリバー", 0, "週3日くらい1人ラーメンします"]
]

name_attrs.each_with_index do |(name, gender, self_introduction), i|
  email = "user#{i+1}@diver.com"
  User.find_or_create_by(email: email) do |user|
    user.name = name
    user.email = email
    user.gender = gender
    user.self_introduction = self_introduction
    user.password = "password"
    user.profile_image = open("#{Rails.root}/db/dummy_images/#{i+1}.jpg")
  end
end
