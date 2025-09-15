# ToDo

I already have some use cases and the cache. The next step is to think about what I want now:
- A new use case for working with audios. VERY COMPLICATED. Do I want to download them? Do I want to save them? Do I want to send them?
----

# Working on RecordingSessionView

## (done)I must create the Wave View
## I have to unify the fields and functions of RECORDINGSESSIONVIEWMODEL and ARTICLELOCALAUDIOSPLAYERVIEWMODEL
    -- (Done) Think how the flow is
    -- Build the new RecordingSession to PracticeSheetFactory
    -- I can transform how ChatMessageView is showed in PracticeSheetView
    -- Create a bar to control the record manager

#Article must change. I have to add image from Simbols SF

## Improvements
To know if the audio has finished playing: func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
onDidFinishPlaying?()
}
- Possible view: https://youtu.be/3uWkdWwWvpc?t=542
