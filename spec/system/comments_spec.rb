require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let!(:user1) { FactoryBot.create(:user1) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:comment1) { FactoryBot.create(:comment1, user: user1, send_user: user1.id) }
  # comment1 = FactoryBot.create(comment1: user: user1, send_user: user1.id)
  let!(:comment2) { FactoryBot.create(:comment2, user: user1, send_user: user2.id) }

  describe 'コメントCURD機能テスト' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: user1.password
      click_button 'ログイン'
      visit user_path(user1)
    end

    context 'コメント投稿した時' do
      it 'コメントが表示される' do
        fill_in 'comment_content', with: 'コメント記入テスト'
        click_on '送信'
        expect(page).to have_content 'コメント記入テスト'
      end
    end

    # context '投稿したコメントを編集した時' do
    #   it '編集される' do
    #     visit user_path(user1)
    #     all('ul cbody li a')[0].click
    #     fill_in "comment_content_#{Comment.first.send_user}", with: "test"
    #     all('ul li input')[0].click
    #     expect(page).to have_content('test')
    #   end
    # end

    context '投稿したコメントを削除した時' do
      it '削除される' do
        visit user_path(user1)
        # all('ul cbody li a')[1].click
        all('cbody a')[0].click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('コメントを削除しました')
      end
    end
  end
end
