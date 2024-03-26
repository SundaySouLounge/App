
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalonStatsComponent } from './salon-stats.component';

describe('SalonStatsComponent', () => {
  let component: SalonStatsComponent;
  let fixture: ComponentFixture<SalonStatsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SalonStatsComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(SalonStatsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
