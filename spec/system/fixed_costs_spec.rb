require 'rails_helper'

RSpec.describe "FixedCosts", type: :system do
  let!(:user1) { FactoryBot.create(:user1) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:fixed_cost) { FactoryBot.create(:fixed_cost, user: user1) }
  let!(:fixed_cost2) { FactoryBot.create(:fixed_cost2, user: user1) }
  let!(:category) { FactoryBot.create(:category, user: user1)}
  let!(:category2) { FactoryBot.create(:category2, user: user1)}
  let!(:categorization) { FactoryBot.create(:categorization, fixed_cost: fixed_cost, category: category) }
  let!(:categorization2) { FactoryBot.create(:categorization, fixed_cost: fixed_cost2, category: category2) }


  describe 'FixedCostのCURD機能テスト' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: user1.password
      click_button 'ログイン'
      visit user_path(user1)
    end

    context '固定費を登録した場合' do
      it '登録される' do
        click_on '品目追加'
        select '保険', from: 'fixed_cost_category_ids'
        select '月額', from: 'fixed_cost_monthly_annual'
        fill_in 'fixed_cost_payment', with: '2000'
        fill_in '詳細', with: '医療保険'
        click_on '登録する'
        expect(page).to have_content '登録しました'
      end
    end
    context '固定費を編集した場合' do
      it '修正される' do
        all('tbody td')[4].click_on '編集'
        select '住宅費', from: 'fixed_cost_category_ids'
        select '年額', from: 'fixed_cost_monthly_annual'
        fill_in 'fixed_cost_payment', with: '600000'
        fill_in '詳細', with: '家賃'
        click_on '更新する'
        expect(page).to have_content '変更しました'
      end
    end
    context '固定費を削除した場合' do
      it '削除される' do
        all('tbody td')[5].click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '削除しました'
      end
    end
  end
end
