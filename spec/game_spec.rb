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
  end
end
