// youtube.service.ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class YouTubeService {
  constructor() {}

  extractVideoId(url: string): string | null {
    const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/;
    const match = url.match(regExp);
    return (match && match[7].length === 11) ? match[7] : null;
  }

  getEmbedUrl(videoId: string): string {
    return `https://www.youtube.com/embed/${videoId}`;
  }
}

// your-component.ts
import { Component } from '@angular/core';
import { YouTubeService } from './youtube.service'; // Adjust the path if necessary

@Component({
  selector: 'app-your-component',
  templateUrl: './your-component.component.html',
  styleUrls: ['./your-component.component.css']
})
export class YourComponent {
  youtubeLink: string;
  embedUrl: string;

  constructor(private youtubeService: YouTubeService) {}

  onYouTubeLinkSubmit() {
    const videoId = this.youtubeService.extractVideoId(this.youtubeLink);
    if (videoId) {
      this.embedUrl = this.youtubeService.getEmbedUrl(videoId);
    } else {
      // Handle invalid URL
    }
  }
}

// your-component.component.html
<div>
  <input [(ngModel)]="youtubeLink" placeholder="Enter YouTube Link" />
  <button (click)="onYouTubeLinkSubmit()">Submit</button>

  <div *ngIf="embedUrl">
    <iframe [src]="embedUrl" frameborder="0" allowfullscreen></iframe>
  </div>
</div>
