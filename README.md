# ClimatePro

Laurier Computing Society Hackathon Submission
Built with love for the enviroment, by The Goofy Goobers: William Burbank & Olivia Brozy

⸻

Hackathon Context:

This project was built for the Laurier Computing Society Hackathon with a focus on:
	•	Practical climate awareness
	•	Clean iOS design
	•	Scalable feature ideas


Notes for Reviewers:

	•	Missing files are intentional due to GitHub limitations
	•	Core functionality and architecture are fully implemented
	•	App is designed to scale with cloud-based assets in production


⸻

Overview:

ClimatePro is an iOS app designed to help users learn, track, and improve their environmental impact through education, habit-building, and interactive tools.

The app combines:
	•	Awareness (carbon footprint education)
	•	Short-form learning videos
	•	Waste sorting assistance
	•	Engagement through gamified features

⸻

Features:
	•	Video Learning
	•	Bite-sized lessons on sustainability and climate topics
	•	Waste Scanner
	•	Helps classify items into recycling, compost, or garbage
	•	AI Integration
	•	Uses OpenAI to provide insights and assistance
	•	Progress Tracking
	•	Encourages sustainable habits over time
	•	Social / Competitive Elements
	•	Inspired by gamified learning (like Duolingo-style engagement)

⸻

⚠️ Important Notes (Setup Required):

Due to GitHub restrictions and security best practices, some files are intentionally not included in this repository:

⸻

Missing Video Files (.mp4):

Video lessons are not included because:
	•	GitHub limits file sizes (100MB max)
	•	Large media files are not suitable for standard repositories

To run the app fully, add your own .mp4 files to:

ClimatePro/Resources/ClimatePro External MP4s/

MAKE SURE THE FILE NAMES MATCH!!!

lesson1.mp4
lesson2.mp4
lesson3.mp4
lesson4.mp4
lesson5.mp4
lesson6.mp4

Missing API Key:

The OpenAI API key has been removed because:
	•	GitHub blocks exposed secrets
	•	Public keys can be abused

To enable AI features:

Open: ClimatePro/Services/OpenAIService.swift

Replace with your own key: let apiKey = "YOUR_API_KEY_HERE"

Requirements:
	•	Xcode 26
	•	iOS 26.4+
	•	macOS compatible with Xcode 26
  
Tech Stack:
	•	Swift (UIKit)
	•	AVKit / AVFoundation (video playback)
	•	OpenAI API
	•	Apple native frameworks
  •	HealthKit


  Future Improvements:
	•	Cloud-hosted video streaming (instead of local files)
	•	User accounts + persistent progress
	•	Real-time carbon tracking integrations
	•	Expanded AI coaching features
	•	Social leaderboards


  
