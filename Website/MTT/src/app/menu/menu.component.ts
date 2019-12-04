import { Component, OnInit, Output, EventEmitter } from '@angular/core';



export enum menu_elements { 
  MTT = "MTT_ADDR",
  OFbiz = "/biz",
  Consul = "/cosnul/ui",
  Fabio = "/fabio",
  Nomad = "/nomad",
  Prometheus = "/prometheus",
  Grafana = "/grafana"} ;

 

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})


export class MenuComponent implements OnInit {

// menu_elements = Object.keys(menu_elements).map(key => menu_elements[key])
  menu_elements= menu_elements;
  @Output() MTT_event = new EventEmitter<string>();
  toggle_side(){
    this.MTT_event.next('toggle');
  //  new AppComponent().navToggle();
  }

  myClickHandler(key){
    if (key == "MTT") {
      this.MTT_event.next('toggle');
    }
  }

  constructor() { }

  ngOnInit() {
  }

 
}
