
import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CategoriesdjComponent } from './categoriesdj.component';

describe('CategoriesdjComponent', () => {
  let component: CategoriesdjComponent;
  let fixture: ComponentFixture<CategoriesdjComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CategoriesdjComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(CategoriesdjComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
