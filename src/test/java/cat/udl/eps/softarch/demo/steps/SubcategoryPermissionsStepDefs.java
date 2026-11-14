package cat.udl.eps.softarch.demo.steps;

import cat.udl.eps.softarch.demo.domain.Category;
import cat.udl.eps.softarch.demo.repository.CategoryRepository;
import cat.udl.eps.softarch.demo.repository.SubcategoryRepository;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.http.MediaType;

import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;

public class SubcategoryPermissionsStepDefs {
    private final StepDefs stepDefs;
    private final CategoryRepository categoryRepository;
    private final SubcategoryRepository subcategoryRepository;

    public SubcategoryPermissionsStepDefs(StepDefs stepDefs, CategoryRepository categoryRepository,
                                          SubcategoryRepository subcategoryRepository) {
        this.stepDefs = stepDefs;
        this.categoryRepository = categoryRepository;
        this.subcategoryRepository = subcategoryRepository;
    }

    @When("I create a subcategory named {string} in category {string}")
    public void iCreateASubcategoryInCategory(String name, String categoryName) throws Exception {
        Category category = categoryRepository.findByName(categoryName).orElseThrow();
        postSubcategory(Map.of("name", name, "category", category.getUri()));
    }

    @When("I create a subcategory named {string} without a category")
    public void iCreateASubcategoryWithoutACategory(String name) throws Exception {
        postSubcategory(Map.of("name", name));
    }

    @When("I delete the subcategory named {string}")
    public void iDeleteTheSubcategoryNamed(String name) throws Exception {
        Long id = subcategoryRepository.findByName(name).get(0).getId();
        stepDefs.result = stepDefs.mockMvc.perform(
                delete("/subcategories/{id}", id)
                    .accept(MediaType.APPLICATION_JSON)
                    .with(AuthenticationStepDefs.authenticate()))
            .andDo(print());
    }

    @Then("the subcategory named {string} has not been created")
    public void theSubcategoryHasNotBeenCreated(String name) {
        assertThat(subcategoryRepository.findByName(name).isEmpty(), is(true));
    }

    @Then("the subcategory named {string} has been created")
    public void theSubcategoryHasBeenCreated(String name) {
        assertThat(subcategoryRepository.findByName(name).isEmpty(), is(false));
    }

    @Then("the subcategory named {string} still exists")
    public void theSubcategoryStillExists(String name) {
        assertThat(subcategoryRepository.findByName(name).isEmpty(), is(false));
    }

    @Then("the subcategory named {string} no longer exists")
    public void theSubcategoryNoLongerExists(String name) {
        assertThat(subcategoryRepository.findByName(name).isEmpty(), is(true));
    }

    private void postSubcategory(Map<String, String> body) throws Exception {
        stepDefs.result = stepDefs.mockMvc.perform(
                post("/subcategories")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(stepDefs.mapper.writeValueAsString(body))
                    .characterEncoding(StandardCharsets.UTF_8)
                    .accept(MediaType.APPLICATION_JSON)
                    .with(AuthenticationStepDefs.authenticate()))
            .andDo(print());
    }
}
