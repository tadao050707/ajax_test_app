require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user1) }
  let!(:user2) { FactoryBot.create(:user2) }

  describe '新規ユーザー登録' do
    context 'ユーザーを新規登録した場合' do
      it 'ユーザーが登録される' do
        visit new_user_registration_path
        fill_in 'ユーザーネーム', with: '新規テストユーザー'
        fill_in 'メールアドレス', with: 'user123@test.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_on 'アカウント登録'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
    context 'ログインまたは登録しないでユーザの詳細画面を「クリック」した場合' do
      it 'ユーザーログイン画面へ遷移する' do
        visit root_path
        click_on "みんなの固定支出はこちらからみれます"
        click_on "テストユーザー２"
        expect(page).to have_selector '.alert', text: 'アカウント登録もしくはログインしてください。'
      end
    end
  end
  describe '管理者機能' do
    context '管理者がログインした場合' do
      it 'サイト管理画面へ遷移できる' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'admin@test.com'
        fill_in 'パスワード', with: 'testuser'
        click_button "ログイン"
        # click_on "管理者画面"
        find("#id_admin").click
        sleep 0.5
        expect(page).to have_selector '.page-header', text: 'サイト管理'
      end
    end
  end
  describe 'ユーザー機能のテスト' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
    context 'ログアウトボタンを押した時' do
      it 'ログアウトできる' do
        click_on "ログアウト"
        expect(page).to have_content 'ログアウトしました。'
      end
    end
    context 'ユーザー情報を編集した時' do
      it 'マイページの内容が編集されている' do
        visit mypage_user_path(user)
        click_on "アカウント設定"
        fill_in 'ユーザーネーム', with: '名前変更'
        fill_in 'プロフィール', with: 'よろしくお願いします'
        click_on '更新'
        expect(page).to have_content '名前変更'
        expect(page).to have_content 'よろしくお願いします'
        expect(page).to have_content 'アカウント情報を変更しました'
      end
    end
    context 'アカウント削除ボタンを押した時' do
      it 'アカウント削除されログインできなくなる' do
        visit mypage_user_path(user)
        click_on "アカウント設定"
        click_on "アカウント削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'アカウントを削除しました。'
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'admin@test.com'
        fill_in 'パスワード', with: 'testuser'
        click_button "ログイン"
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
