import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TracktraceComponent } from './tracktrace.component';

describe('TracktraceComponent', () => {
  let component: TracktraceComponent;
  let fixture: ComponentFixture<TracktraceComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TracktraceComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TracktraceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
