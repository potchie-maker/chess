require_relative "../lib/game"

describe Game do
  describe "#convert_notation_to_row_col" do
    subject(:game_convert) { described_class.new }

    context "when converting string notation" do

      it "correctly converts e4" do
        expect(game_convert.convert_notation_to_row_col("e4")).to eq([4, 4])
      end

      it "correctly converts c7" do
        expect(game_convert.convert_notation_to_row_col("c7")).to eq([1, 2])
      end

      it "correctly converts g3" do
        expect(game_convert.convert_notation_to_row_col("g3")).to eq([5, 6])
      end
    end
  end

  describe "get_move" do
    subject(:game_move) { described_class.new }

    context "when given valid input" do
      before do
        valid_input = "d5 > e4"
        allow(game_move).to receive(:gets).and_return(valid_input)
        allow(game_move).to receive(:puts)
      end

      it "returns the correct start and fin" do
        expect(game_move.get_move).to eq([[3, 3], [4, 4]])
      end
    end
    
    context "when given one invalid input" do
      before do
        invalid_input = "s7 > i9"
        valid_input = "g7 > h8"
        allow(game_move).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game_move).to receive(:puts)
      end

      it "gives error message once" do
        err_msg = "\n\nInvalid move input. Try again."
        expect(game_move).to receive(:puts).with(err_msg).once
        game_move.get_move
      end
    end
  end

  describe "#find_kings" do
    subject(:game_kings) { described_class.new }

    context "when searching for kings" do

      it "returns correct king positions" do
        king_one = King.new("white", [0, 1])
        king_two = King.new("black", [1, 0])
        board = [
          [nil, king_one, nil],
          [king_two, nil, nil]
        ]
        first_pos = [0, 1]
        sec_pos = [1, 0]
        expect(game_kings.find_kings(board)).to eq([first_pos, sec_pos])
      end
    end
  end
end
