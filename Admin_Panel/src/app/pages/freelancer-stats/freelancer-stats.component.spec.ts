
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FreelancerStatsComponent } from './freelancer-stats.component';

describe('FreelancerStatsComponent', () => {
  let component: FreelancerStatsComponent;
  let fixture: ComponentFixture<FreelancerStatsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FreelancerStatsComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(FreelancerStatsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
