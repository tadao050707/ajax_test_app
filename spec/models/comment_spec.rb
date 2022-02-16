require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user1) }

  describe 'コメント入力数のテスト' do
    context 'コメント数が256字以上の場合' do
      it 'バリデーションエラーになる' do
        comment = Comment.new(content: 'a' * 256,  user: user)
        expect(comment).to be_invalid
      end
    end
    context 'コメントを空で入力した場合' do
      it 'バリデーションエラーになる' do
        comment = Comment.new(content: '', user: user)
        expect(comment).to be_invalid
      end
    end
  end
end
