# ToDo

I already have some use cases and the cache. The next step is to think about what I want now:
- A new use case for working with audios. VERY COMPLICATED. Do I want to download them? Do I want to save them? Do I want to send them?
----

# Time to deal with the audios and how I'm going to set up the view
- Proposed view
- Use case already exists
- Possible view: https://youtu.be/3uWkdWwWvpc?t=542

## Dealing with audio recording
- Do I have a use case?
- I have the interface:
    - I have the Infrastructure
    - Let's work on the Repository/Data Source
        -- (Done) Define Mapper and Errors
--

## Improvements
To know if the audio has finished playing: func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
onDidFinishPlaying?()
}
