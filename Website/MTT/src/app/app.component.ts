import { Component, ViewChild, Input } from '@angular/core';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'MTT';
  show_MTT = false;
  // matDrawer = new MatDrawer('drawer');

  onClick_S_MTT(){
    this.show_MTT = !this.show_MTT;
  }
}
