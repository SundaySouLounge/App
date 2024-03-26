
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalonsComponent } from './salons.component';

describe('SalonsComponent', () => {
  let component: SalonsComponent;
  let fixture: ComponentFixture<SalonsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SalonsComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(SalonsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
