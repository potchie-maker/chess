require_relative "../lib/piece"

describe Piece do
  describe "#convert_notation_to_row_col" do
    context "when converting string notation" do
      subject(:piece_convert) { described_class.new("white", [6, 0]) }

      it "correctly converts e4" do
        expect(piece_convert.convert_notation_to_row_col("e4")).to eq([4, 4])
      end

      it "correctly converts c7" do
        expect(piece_convert.convert_notation_to_row_col("c7")).to eq([1, 2])
      end

      it "correctly converts g3" do
        expect(piece_convert.convert_notation_to_row_col("g3")).to eq([5, 6])
      end
    end
  end
end
