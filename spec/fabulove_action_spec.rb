describe Fastlane::Actions::FabuloveAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The fabulove plugin is working!")

      Fastlane::Actions::FabuloveAction.run(nil)
    end
  end
end
