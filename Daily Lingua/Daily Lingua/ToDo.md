# ToDo

I already have some use cases and the cache. The next step is to think about what I want now:
- A new use case for working with audios. VERY COMPLICATED. Do I want to download them? Do I want to save them? Do I want to send them?
----

# Time to deal with the audios and how I'm going to set up the view
- Proposed view
- Use case already exists
- Possible view: https://youtu.be/3uWkdWwWvpc?t=542

## Dealing with audio recording
- I have the interface:
    - I have the Infrastructure
    - (Done)Let's work on the Repository/Data Source
        -- (Done) Define Mapper and Errors
    - (Done) I'll work with DTO with just 1 field with value. I'll create use cases for: record, cancel and so on. Also I'll create a case to "unify" all paths in just 1 Entity.
- I can already work with uses Cases
-- I will have to implement cache in ArticleAudiosRecordRepository

## Improvements
To know if the audio has finished playing: func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
onDidFinishPlaying?()
}
