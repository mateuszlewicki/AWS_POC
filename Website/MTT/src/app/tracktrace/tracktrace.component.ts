import { Component, OnInit } from '@angular/core';

export interface PeriodicElement {
  pkgNum: string;
  from: string;
  to: string;
  message: string;
  postOffice: string;
  date: string;
}

const ELEMENT_DATA: PeriodicElement[] = [
  {pkgNum: "ABC123", from: 'ME', to: "you", message: 'i love',postOffice: "Pol",date:"24/11/2019 20:08:25 UTC+01:00"}
];


@Component({
  selector: 'app-tracktrace',
  templateUrl: './tracktrace.component.html',
  styleUrls: ['./tracktrace.component.css']
})
export class TracktraceComponent implements OnInit {


  displayedColumns: string[] = ['pkgNum', 'from', 'to', 'message','postOffice','date'];
  dataSource = ELEMENT_DATA;

  constructor() { }

  ngOnInit() {
  }

}
