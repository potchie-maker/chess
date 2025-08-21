require_relative "../lib/board"

describe Board do
  describe "#transform_board" do
    context "when no moves have been made" do
      subject(:game_transform) { described_class.new }

      it "has the pieces in the correct position" do
        correct_layout = [
          ["♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"],
          ["♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"],
          ["□", "■", "□", "■", "□", "■", "□", "■"],
          ["■", "□", "■", "□", "■", "□", "■", "□"],
          ["□", "■", "□", "■", "□", "■", "□", "■"],
          ["■", "□", "■", "□", "■", "□", "■", "□"],
          ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
          ["♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"],
        ]
        game_transform.set_up
        expect(game_transform.transform_board).to eq(correct_layout)
      end
    end
  end
end
