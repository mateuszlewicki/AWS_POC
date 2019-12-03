import { Component, OnInit, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

@Output() someEvent = new EventEmitter<string>();
  toggle_side(){
    this.someEvent.next('toggle');
  //  new AppComponent().navToggle();
  }
  constructor() { }

  ngOnInit() {
  }

}
