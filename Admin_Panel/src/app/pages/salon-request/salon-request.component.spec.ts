
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalonRequestComponent } from './salon-request.component';

describe('SalonRequestComponent', () => {
  let component: SalonRequestComponent;
  let fixture: ComponentFixture<SalonRequestComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SalonRequestComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(SalonRequestComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
