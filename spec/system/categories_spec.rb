require 'rails_helper'

RSpec.describe "Categories", type: :system do
  let!(:user1) { FactoryBot.create(:user1) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:category) { FactoryBot.create(:category, user: user1) }
  let!(:category2) { FactoryBot.create(:category2, user: user1) }

  describe 'カテゴリCRUD機能' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: user1.password
      click_button 'ログイン'
      visit new_category_path
    end

    context 'ユーザーがカテゴリを作成した時' do
      it '新しいカテゴリーが作成される' do
        fill_in 'カテゴリ名', with: 'サブスクリプション'
        click_button '登録'
        expect(page).to have_content 'サブスクリプション'
        expect(current_path).to eq new_category_path
      end
    end
    context 'カテゴリ編集をした時' do
      it '編集できる' do
        # click_on '編集'
        all('tbody td')[1].click_on '編集'
        fill_in 'カテゴリ名', with: '編集したカテゴリー'
        click_on '変更'
        expect(page).to have_content '変更しました'
      end
    end
    context 'カテゴリを削除した時' do
      it '削除される' do
        # binding.pry
        all('tbody td')[2].click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '削除しました'
      end
    end
  end
end
