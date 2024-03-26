
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FreelancerAppointmentsComponent } from './freelancer-appointments.component';

describe('FreelancerAppointmentsComponent', () => {
  let component: FreelancerAppointmentsComponent;
  let fixture: ComponentFixture<FreelancerAppointmentsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FreelancerAppointmentsComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(FreelancerAppointmentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
