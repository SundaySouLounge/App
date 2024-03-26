
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FreelancerRequestComponent } from './freelancer-request.component';

describe('FreelancerRequestComponent', () => {
  let component: FreelancerRequestComponent;
  let fixture: ComponentFixture<FreelancerRequestComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FreelancerRequestComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(FreelancerRequestComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
