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

  describe "#convert_notation" do
    context "when converting string notation" do
      subject(:board_convert) { described_class.new }

      it "correctly converts e4" do
        expect(board_convert.convert_notation("e4")).to eq([4, 4])
      end

      it "correctly converts c7" do
        expect(board_convert.convert_notation("c7")).to eq([1, 2])
      end

      it "correctly converts g3" do
        expect(board_convert.convert_notation("g3")).to eq([5, 6])
      end
    end
  end
end
